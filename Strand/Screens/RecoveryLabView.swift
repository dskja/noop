import SwiftUI
import StrandDesign
import StrandAnalytics
import WhoopStore

// RecoveryLabView.swift — a dedicated recovery deep-dive screen combining the
// Charge driver breakdown, tomorrow's forecast, the rolling sleep-debt ledger,
// and a recovery trend chart with personal-baseline bands. All data is derived
// from the same `repo.days` / `repo.today` the Today and Sleep screens read,
// so every number stays consistent with the dashboard. Pure presentation — no
// store reads, no recomputation of scores; the engines (RecoveryScorer,
// RecoveryForecaster, SleepDebt, Baselines) supply every value.

struct RecoveryLabView: View {
    @EnvironmentObject private var repo: Repository

    // yyyy-MM-dd → Date (en_US_POSIX, UTC), matching TrendsView's parser.
    private static let dayParser: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(identifier: "UTC")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    var body: some View {
        ScreenScaffold(title: "Recovery Lab",
                       subtitle: "Charge breakdown, forecast & sleep debt",
                       lazy: true) {
            VStack(alignment: .leading, spacing: NoopMetrics.sectionGap) {
                chargeDriversSection
                forecastSection
                sleepDebtSection
                recoveryTrendSection
            }
        }
    }

    // MARK: - 1. Charge Drivers breakdown

    /// The most recent day with a scored recovery — mirrors TodayView's `chargeBreakdownRow`
    /// carry-over logic (today's own scored row, else the last scored day).
    private var displayDay: DailyMetric? {
        repo.today ?? repo.days.last(where: { $0.recovery != nil })
    }

    /// The ordered Charge drivers for the displayed row. PURE derivation from the same
    /// `displayDay` + folded baselines the Today screen uses — never a second store read.
    private var chargeDrivers: [ChargeDriver] {
        guard let row = displayDay,
              let hrv = row.avgHrv, let rhr = row.restingHr else { return [] }
        let hrvBase = Baselines.foldHistory(repo.days.map(\.avgHrv), cfg: Baselines.hrvCfg)
        guard hrvBase.usable else { return [] }
        let rhrBase = Baselines.foldHistory(repo.days.map { $0.restingHr.map(Double.init) },
                                            cfg: Baselines.restingHRCfg)
        let respBase = Baselines.foldHistory(repo.days.map(\.respRateBpm), cfg: Baselines.respCfg)
        let sleepPerf = displayDay?.efficiency.map { $0 / 100.0 }
        return RecoveryScorer.chargeDrivers(
            hrv: hrv, rhr: Double(rhr), resp: row.respRateBpm,
            hrvBaseline: hrvBase,
            rhrBaseline: rhrBase.usable ? rhrBase : nil,
            respBaseline: respBase.usable ? respBase : nil,
            sleepPerf: sleepPerf, skinTempDev: row.skinTempDevC)
    }

    private var chargeConfidence: ScoreConfidence {
        let hrvBase = Baselines.foldHistory(repo.days.map(\.avgHrv), cfg: Baselines.hrvCfg)
        return ScoreConfidence.charge(recovery: displayDay?.recovery, hrvBaseline: hrvBase)
    }

    private var chargeSkinTempRel: SkinTempRelative? {
        RecoveryScorer.skinTempRelative(deviationC: displayDay?.skinTempDevC)
    }

    @ViewBuilder
    private var chargeDriversSection: some View {
        VStack(alignment: .leading, spacing: NoopMetrics.gap) {
            SectionHeader("Charge Breakdown",
                          overline: "What shaped it",
                          trailing: String(localized: "Today"))
            let drivers = chargeDrivers
            if drivers.isEmpty {
                NoopCard {
                    VStack(spacing: NoopMetrics.space2) {
                        Text("Calibrating")
                            .font(StrandFont.title2)
                            .foregroundStyle(StrandPalette.textPrimary)
                        Text("Your Charge drivers will appear once your HRV baseline is ready (4+ nights).")
                            .font(StrandFont.subhead)
                            .foregroundStyle(StrandPalette.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                NoopCard {
                    ChargeBreakdownSection(
                        drivers: drivers,
                        confidence: chargeConfidence,
                        skinTempRel: chargeSkinTempRel)
                }
            }
        }
    }

    // MARK: - 2. Recovery Forecast

    /// Evening forecast of tomorrow-morning Charge, mirroring IntelligenceView's derivation.
    /// `repo.days` is oldest→newest; the forecaster wants oldest→newest, so no reverse needed.
    private var forecast: RecoveryForecast? {
        let charge = repo.days.compactMap(\.recovery)
        let effort = repo.days.compactMap(\.strain)
        let sleeps = repo.days.compactMap(\.totalSleepMin)
        let plannedHours = sleeps.isEmpty
            ? RecoveryForecaster.defaultNeedHours
            : (sleeps.reduce(0, +) / Double(sleeps.count)) / 60.0
        return RecoveryForecaster.forecast(
            recentCharge: charge,
            recentEffort: effort,
            todayEffort: repo.days.last?.strain,
            plannedSleepHours: plannedHours)
    }

    @ViewBuilder
    private var forecastSection: some View {
        VStack(alignment: .leading, spacing: NoopMetrics.gap) {
            SectionHeader("Tomorrow's Charge",
                          overline: "Evening forecast",
                          trailing: String(localized: "Estimate"))
            if let f = forecast {
                NoopCard(padding: 20, tint: StrandPalette.chargeColor) {
                    VStack(spacing: 14) {
                        ZStack {
                            LiquidVessel(value: min(max(f.charge / 100.0, 0), 1),
                                         tint: StrandPalette.recoveryColor(f.charge),
                                         animated: true)
                                .frame(width: 184, height: 184)
                            VStack(spacing: 0) {
                                CountUpText(
                                    value: f.charge,
                                    format: { "\(Int($0.rounded()))" },
                                    font: StrandFont.rounded(52),
                                    color: StrandPalette.textPrimary)
                                Text("± \(Int(f.band.rounded())) · \(StrandPalette.recoveryState(f.charge))")
                                    .font(StrandFont.captionNumber)
                                    .foregroundStyle(StrandPalette.textSecondary)
                            }
                            .allowsHitTesting(false)
                        }
                        .padding(.top, 4)
                        .padding(.bottom, 6)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Tomorrow's Charge estimate \(Int(f.charge.rounded())) plus or minus \(Int(f.band.rounded()))")
                        VStack(alignment: .leading, spacing: 10) {
                            Text("You'll likely wake around \(Int(f.charge.rounded())) ± \(Int(f.band.rounded())) Charge if you sleep about \(sleepHoursLabel(f.plannedSleepHours)) tonight.")
                                .font(StrandFont.subhead)
                                .foregroundStyle(StrandPalette.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Estimate from today's effort, your typical sleep and your \(f.nights)-night recovery baseline, not a measurement. Your real Charge is scored from tomorrow's HRV when you wake.")
                                .font(StrandFont.footnote)
                                .foregroundStyle(StrandPalette.textTertiary)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            } else {
                NoopCard {
                    VStack(spacing: NoopMetrics.space2) {
                        Text("Forecast unavailable")
                            .font(StrandFont.title2)
                            .foregroundStyle(StrandPalette.textPrimary)
                        Text("Needs at least 5 nights of scored Charge to project tomorrow's recovery.")
                            .font(StrandFont.subhead)
                            .foregroundStyle(StrandPalette.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    /// Format sleep hours as "Xh Ym" for the forecast copy.
    private func sleepHoursLabel(_ hours: Double) -> String {
        let m = Int((hours * 60).rounded())
        if m < 60 { return "\(m)m" }
        return "\(m / 60)h \(m % 60)m"
    }

    // MARK: - 3. Sleep Debt Tracker

    /// Personal sleep need (minutes): mean asleep, floored at 7.5h — mirrors SleepView.
    private var sleepNeedMin: Double {
        let typical = repo.days.compactMap(\.totalSleepMin).filter { $0 > 0 }
        let mean = typical.isEmpty ? 450.0 : typical.reduce(0, +) / Double(typical.count)
        return Swift.max(450, mean)
    }

    /// Rolling 14-night sleep-debt ledger — same derivation as SleepView.
    private var debtLedger: SleepDebtLedger {
        SleepDebt.ledger(
            series: repo.days.map { (day: $0.day, totalSleepMin: $0.totalSleepMin) },
            needHours: sleepNeedMin / 60.0)
    }

    @ViewBuilder
    private var sleepDebtSection: some View {
        let ledger = debtLedger
        VStack(alignment: .leading, spacing: NoopMetrics.gap) {
            SectionHeader("Sleep-debt Ledger",
                          overline: "Last 14 nights",
                          trailing: String(localized: "running balance"))
            NoopCard {
                VStack(alignment: .leading, spacing: NoopMetrics.cardInnerSpacing) {
                    // Headline balance
                    HStack(alignment: .firstTextBaseline) {
                        Text(debtHeadline(ledger))
                            .font(StrandFont.number(26))
                            .foregroundStyle(debtBalanceColor(ledger))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                        Spacer(minLength: NoopMetrics.space2)
                        Text(debtTag(ledger))
                            .font(StrandFont.captionNumber)
                            .foregroundStyle(debtBalanceColor(ledger))
                    }
                    Text(debtRead(ledger))
                        .font(StrandFont.subhead)
                        .foregroundStyle(StrandPalette.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                    // Per-night delta bars
                    if !ledger.nights.isEmpty {
                        debtDeltaBars(ledger)
                            .frame(height: 64)
                            .padding(.top, NoopMetrics.space1)
                    }
                }
            }
        }
    }

    /// Diverging per-night delta strip — each night a bar from the centre line.
    @ViewBuilder
    private func debtDeltaBars(_ ledger: SleepDebtLedger) -> some View {
        let deltas = ledger.nights.map(\.deltaMin)
        let scale = max(deltas.map { abs($0) }.max() ?? 1, 1)
        GeometryReader { geo in
            let n = deltas.count
            if n == 0 {
                EmptyView()
            } else {
                let barW = max(6, (geo.size.width - CGFloat(n - 1) * 3) / CGFloat(n))
                let midY = geo.size.height / 2
                HStack(alignment: .center, spacing: 3) {
                    ForEach(Array(deltas.enumerated()), id: \.offset) { _, delta in
                        let h = max(3, abs(delta) / scale * midY * 0.9)
                        let isSurplus = delta >= 0
                        Rectangle()
                            .fill(isSurplus ? StrandPalette.statusPositive : StrandPalette.metricRose)
                            .frame(width: barW, height: h)
                            .offset(y: isSurplus ? -(midY - h) / 2 : (midY - h) / 2)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .overlay(alignment: .center) {
                    Rectangle()
                        .fill(StrandPalette.hairline)
                        .frame(height: 1)
                }
            }
        }
    }

    private func debtHeadline(_ ledger: SleepDebtLedger) -> String {
        if ledger.magnitudeMin < SleepDebt.onTargetBandMin { return String(localized: "On target") }
        let m = Swift.max(0, Int(ledger.magnitudeMin.rounded()))
        if m < 60 { return "≈\(m)m" }
        return "≈\(m / 60)h \(m % 60)m"
    }

    private func debtTag(_ ledger: SleepDebtLedger) -> String {
        if ledger.magnitudeMin < SleepDebt.onTargetBandMin { return String(localized: "balanced") }
        return ledger.isDebt ? String(localized: "sleep debt") : String(localized: "surplus")
    }

    private func debtRead(_ ledger: SleepDebtLedger) -> String {
        let nights = ledger.nightCount
        let span = nights == 1
            ? String(localized: "the last night")
            : String(localized: "the last \(nights) nights")
        if ledger.magnitudeMin < SleepDebt.onTargetBandMin {
            return String(localized: "Your sleep is balanced over \(span).")
        }
        if ledger.isDebt {
            return String(localized: "You're carrying ≈\(durationText(ledger.magnitudeMin)) of sleep debt over \(span).")
        }
        return String(localized: "You have ≈\(durationText(ledger.magnitudeMin)) of sleep surplus over \(span).")
    }

    private func debtBalanceColor(_ ledger: SleepDebtLedger) -> Color {
        if ledger.magnitudeMin < SleepDebt.onTargetBandMin || !ledger.isDebt {
            return StrandPalette.statusPositive
        }
        if ledger.magnitudeMin < 120 { return StrandPalette.statusWarning }
        return StrandPalette.statusCritical
    }

    private func durationText(_ minutes: Double) -> String {
        let m = Swift.max(0, Int(minutes.rounded()))
        if m < 60 { return "\(m)m" }
        return "\(m / 60)h \(m % 60)m"
    }

    // MARK: - 4. Recovery Trend with baseline bands

    /// Recovery trend points from `repo.days`, oldest→newest.
    private var recoveryPoints: [TrendPoint] {
        repo.days.compactMap { d in
            guard let v = d.recovery,
                  let dt = Self.dayParser.date(from: d.day) else { return nil }
            return TrendPoint(date: dt, value: v)
        }
    }

    /// MetricCfg for recovery (0–100 Charge scale) — the built-in configs are keyed to
    /// physiological ranges (HRV 5–250, RHR 30–120, etc.), so recovery needs its own.
    private static let recoveryCfg = MetricCfg(minVal: 0, maxVal: 100, floorSpread: 8.0,
                                               halfLifeB: 14.0, halfLifeS: 21.0)

    /// The folded recovery baseline state for the trend chart's baseline annotation.
    private var recoveryBaseline: BaselineState {
        Baselines.foldHistory(repo.days.map(\.recovery), cfg: Self.recoveryCfg)
    }

    @ViewBuilder
    private var recoveryTrendSection: some View {
        VStack(alignment: .leading, spacing: NoopMetrics.gap) {
            SectionHeader("Recovery Trend",
                          overline: "Charge over time",
                          trailing: String(localized: "History"))
            let pts = recoveryPoints
            if pts.count < 2 {
                NoopCard {
                    VStack(spacing: NoopMetrics.space2) {
                        Text("Not enough data")
                            .font(StrandFont.title2)
                            .foregroundStyle(StrandPalette.textPrimary)
                        Text("At least 2 scored nights are needed to draw a trend.")
                            .font(StrandFont.subhead)
                            .foregroundStyle(StrandPalette.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                NoopCard {
                    VStack(alignment: .leading, spacing: NoopMetrics.cardInnerSpacing) {
                        TrendChart(
                            points: pts,
                            gradient: StrandPalette.recoveryGradient,
                            valueRange: 0...100,
                            showsArea: true,
                            height: NoopMetrics.chartHeight,
                            showsHover: true,
                            valueFormat: { String(Int($0.rounded())) },
                            accessibilityLabel: "Recovery trend",
                            nowCapColor: StrandPalette.chargeColor
                        )
                        // Baseline annotation
                        let base = recoveryBaseline
                        if base.usable {
                            HStack(spacing: NoopMetrics.space2) {
                                Circle()
                                    .fill(StrandPalette.textTertiary)
                                    .frame(width: 7, height: 7)
                                Text("Baseline: \(Int(base.baseline.rounded())) Charge (\(base.nValid) nights)")
                                    .font(StrandFont.caption)
                                    .foregroundStyle(StrandPalette.textSecondary)
                                Spacer(minLength: 0)
                                if let latest = pts.last {
                                    let delta = latest.value - base.baseline
                                    TrendChip(
                                        text: String(format: "%@%.0f", delta >= 0 ? "+" : "", delta),
                                        color: delta >= 0 ? StrandPalette.statusPositive : StrandPalette.metricRose)
                                }
                            }
                            .padding(.top, NoopMetrics.space1)
                        }
                    }
                }
            }
        }
    }
}
