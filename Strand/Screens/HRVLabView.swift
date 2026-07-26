import SwiftUI
import StrandDesign
import StrandAnalytics
import WhoopStore
import WhoopProtocol

// HRVLabView.swift — a dedicated HRV deep-dive screen combining today's HRV
// with its personal-baseline delta, related vitals tiles, advanced on-demand
// HRV readouts (time-domain, frequency-domain, Baevsky Stress Index, Poincaré
// scatter plot), an HRV trend chart with baseline bands and range selection,
// and a 7-day HRV distribution histogram. All daily data comes from `repo.days`
// / `repo.today`; the advanced readouts are computed live from today's banked
// R-R intervals — the same data the Stress screen reads.
// Pure presentation — no recomputation of nightly HRV scores.

struct HRVLabView: View {
    @EnvironmentObject private var repo: Repository

    // yyyy-MM-dd → Date (en_US_POSIX, UTC), matching TrendsView / RecoveryLabView.
    private static let dayParser: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(identifier: "UTC")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    // MARK: - Advanced readout state (computed async from today's R-R)

    @State private var hrvResult: HRVAnalyzer.HRVResult?
    @State private var stressIndex: StressIndex.Components?
    @State private var freqHRV: HRVFreqDomain.Bands?
    @State private var rhythm: RhythmScreener.WindowResult?
    @State private var advancedLoaded = false

    // MARK: - Trend range

    @State private var range: ExploreRange = .month

    // MARK: - Body

    var body: some View {
        ScreenScaffold(title: "HRV Lab",
                       subtitle: "Heart rate variability deep dive",
                       onRefresh: { await repo.refresh() },
                       lazy: true,
                       topBackground: liquidScaffoldSky()) {
            VStack(alignment: .leading, spacing: NoopMetrics.sectionSpacing) {
                heroSection
                    .staggeredAppear(index: 0)
                vitalsSection
                    .staggeredAppear(index: 1)
                advancedHRVSection
                    .staggeredAppear(index: 2)
                trendSection
                    .staggeredAppear(index: 3)
                distributionSection
                    .staggeredAppear(index: 4)
            }
        }
        .task(id: repo.refreshSeq) { await loadAdvancedReadouts() }
    }

    // MARK: - Data access

    /// The most recent day with an HRV value — mirrors RecoveryLabView's displayDay pattern.
    private var displayDay: DailyMetric? {
        repo.today ?? repo.days.last(where: { $0.avgHrv != nil })
    }

    /// The folded HRV baseline state from all nightly avgHrv values.
    private var hrvBaseline: BaselineState {
        Baselines.foldHistory(repo.days.map(\.avgHrv), cfg: Baselines.hrvCfg)
    }

    /// Today's HRV deviation from the personal baseline.
    private var hrvDeviation: Deviation? {
        guard let hrv = displayDay?.avgHrv, hrvBaseline.usable else { return nil }
        return Baselines.deviation(hrv, state: hrvBaseline)
    }

    // MARK: - 1. Hero — today's HRV with baseline delta

    @ViewBuilder
    private var heroSection: some View {
        VStack(alignment: .leading, spacing: NoopMetrics.gap) {
            SectionHeader("Heart Rate Variability",
                          overline: "Today",
                          trailing: String(localized: "RMSSD"))

            let base = hrvBaseline
            if let hrv = displayDay?.avgHrv {
                NoopCard(tint: StrandPalette.metricPurple) {
                    VStack(alignment: .leading, spacing: NoopMetrics.cardInnerSpacing) {
                        HStack(alignment: .firstTextBaseline, spacing: NoopMetrics.space2) {
                            Text("\(Int(hrv.rounded()))")
                                .font(StrandFont.number(48))
                                .foregroundStyle(StrandPalette.textPrimary)
                            Text("ms")
                                .font(StrandFont.headline)
                                .foregroundStyle(StrandPalette.textTertiary)
                            Spacer(minLength: 0)
                            if let dev = hrvDeviation {
                                TrendChip(
                                    text: String(format: "%@%.0f%%", dev.ratio >= 0 ? "+" : "", dev.ratio * 100),
                                    color: dev.ratio >= 0 ? StrandPalette.statusPositive : StrandPalette.metricRose)
                            }
                        }

                        if base.usable {
                            HStack(spacing: NoopMetrics.space2) {
                                Circle()
                                    .fill(StrandPalette.textTertiary)
                                    .frame(width: 7, height: 7)
                                Text("Baseline: \(Int(base.baseline.rounded())) ms (\(base.nValid) nights)")
                                    .font(StrandFont.caption)
                                    .foregroundStyle(StrandPalette.textSecondary)
                                Spacer(minLength: 0)
                                if let dev = hrvDeviation {
                                    Text(dev.inNormalRange
                                         ? String(localized: "In your normal range")
                                         : (dev.z > 0
                                            ? String(localized: "Above normal")
                                            : String(localized: "Below normal")))
                                        .font(StrandFont.caption)
                                        .foregroundStyle(dev.inNormalRange
                                                         ? StrandPalette.textTertiary
                                                         : (dev.z > 0
                                                            ? StrandPalette.statusPositive
                                                            : StrandPalette.metricRose))
                                }
                            }
                        } else {
                            Text("Baseline calibrating — \(base.nValid)/\(Baselines.minNightsSeed) nights")
                                .font(StrandFont.caption)
                                .foregroundStyle(StrandPalette.textTertiary)
                        }
                    }
                }
            } else {
                NoopCard {
                    VStack(spacing: NoopMetrics.space2) {
                        Text("No HRV yet")
                            .font(StrandFont.title2)
                            .foregroundStyle(StrandPalette.textPrimary)
                        Text("Your nightly HRV (RMSSD) will appear here after your first sleep with the strap.")
                            .font(StrandFont.subhead)
                            .foregroundStyle(StrandPalette.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    // MARK: - 2. Today's related vitals

    @ViewBuilder
    private var vitalsSection: some View {
        VStack(alignment: .leading, spacing: NoopMetrics.gap) {
            SectionHeader("Related Vitals",
                          overline: "Today",
                          trailing: String(localized: "Resting"))

            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 168), spacing: NoopMetrics.gap)],
                alignment: .leading,
                spacing: NoopMetrics.gap
            ) {
                StatTile(
                    label: "Resting HR",
                    value: displayDay?.restingHr.map { "\($0) bpm" } ?? "—",
                    caption: String(localized: "Lower resting HR generally means better recovery."),
                    accent: StrandPalette.metricRose
                )
                StatTile(
                    label: "Respiration",
                    value: displayDay?.respRateBpm.map { String(format: "%.1f br/min", $0) } ?? "—",
                    caption: String(localized: "Breathing rate during rest."),
                    accent: StrandPalette.metricCyan
                )
                StatTile(
                    label: "Skin Temp",
                    value: displayDay?.skinTempDevC.map { String(format: "%+.1f°C", $0) } ?? "—",
                    caption: String(localized: "Deviation from your baseline skin temperature."),
                    accent: StrandPalette.metricAmber
                )
            }
        }
    }

    // MARK: - 3. Advanced HRV readouts (from today's R-R intervals)

    private var hasAdvancedReadouts: Bool {
        hrvResult != nil || stressIndex != nil || freqHRV != nil || rhythm != nil
    }

    @ViewBuilder
    private var advancedHRVSection: some View {
        VStack(alignment: .leading, spacing: NoopMetrics.gap) {
            SectionHeader("Advanced HRV",
                          overline: "On demand",
                          trailing: String(localized: "Today's R-R"))

            if !hasAdvancedReadouts && advancedLoaded {
                NoopCard {
                    VStack(spacing: NoopMetrics.space2) {
                        Text("No R-R intervals today")
                            .font(StrandFont.title2)
                            .foregroundStyle(StrandPalette.textPrimary)
                        Text("Advanced HRV readouts (SDNN, pNN50, LF/HF, Poincaré) appear when today's beat-to-beat intervals are available.")
                            .font(StrandFont.subhead)
                            .foregroundStyle(StrandPalette.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else if !advancedLoaded {
                NoopCard {
                    HStack {
                        ProgressView()
                            .tint(StrandPalette.metricPurple)
                        Text("Reading today's R-R intervals…")
                            .font(StrandFont.subhead)
                            .foregroundStyle(StrandPalette.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                NoopCard(tint: StrandPalette.metricPurple) {
                    VStack(alignment: .leading, spacing: NoopMetrics.cardInnerSpacing) {
                        // Time-domain HRV tiles
                        if let hrv = hrvResult {
                            Text("Time-Domain").strandOverline()
                            LazyVGrid(
                                columns: [GridItem(.adaptive(minimum: 168), spacing: NoopMetrics.gap)],
                                alignment: .leading,
                                spacing: NoopMetrics.gap
                            ) {
                                StatTile(
                                    label: "RMSSD",
                                    value: hrv.rmssd.map { String(format: "%.1f ms", $0) } ?? "—",
                                    caption: String(localized: "Root mean square of successive R-R differences. The primary HRV metric."),
                                    accent: StrandPalette.metricPurple
                                )
                                StatTile(
                                    label: "SDNN",
                                    value: hrv.sdnn.map { String(format: "%.1f ms", $0) } ?? "—",
                                    caption: String(localized: "Standard deviation of all R-R intervals. Reflects overall variability."),
                                    accent: StrandPalette.metricPurple
                                )
                                StatTile(
                                    label: "Mean NN",
                                    value: hrv.meanNN.map { String(format: "%.0f ms", $0) } ?? "—",
                                    caption: String(localized: "Average R-R interval length."),
                                    accent: StrandPalette.metricPurple
                                )
                                StatTile(
                                    label: "pNN50",
                                    value: hrv.pnn50.map { String(format: "%.1f%%", $0) } ?? "—",
                                    caption: String(localized: "Percentage of successive R-R differences > 50 ms."),
                                    accent: StrandPalette.metricPurple
                                )
                            }
                        }

                        if hrvResult != nil && (stressIndex != nil || freqHRV != nil || rhythm != nil) {
                            Divider().background(StrandPalette.hairline)
                        }

                        // Baevsky Stress Index
                        if let si = stressIndex {
                            StatTile(
                                label: "Baevsky Stress Index",
                                value: "\(Int(si.si.rounded()))",
                                caption: String(localized: "Autonomic rigidity from heart-rate rhythm. Higher means a more rigid, stressed rhythm."),
                                accent: StrandPalette.metricRose
                            )
                        }

                        // Frequency-domain HRV
                        if let f = freqHRV {
                            if hrvResult != nil || stressIndex != nil {
                                Divider().background(StrandPalette.hairline)
                            }
                            Text("Frequency-Domain").strandOverline()
                            LazyVGrid(
                                columns: [GridItem(.adaptive(minimum: 168), spacing: NoopMetrics.gap)],
                                alignment: .leading,
                                spacing: NoopMetrics.gap
                            ) {
                                if let ratio = f.lfhf {
                                    StatTile(
                                        label: "LF/HF Ratio",
                                        value: String(format: "%.1f", ratio),
                                        caption: String(localized: "Sympathetic vs parasympathetic balance. Higher leans sympathetic (stress-ward)."),
                                        accent: StrandPalette.metricCyan
                                    )
                                } else if f.hf > 0 {
                                    StatTile(
                                        label: "HF Power",
                                        value: "\(Int(f.hf.rounded()))",
                                        caption: String(localized: "Parasympathetic (rest) band power. LF/HF unavailable — R-R span too short."),
                                        accent: StrandPalette.metricCyan
                                    )
                                }
                                StatTile(
                                    label: "Total Power",
                                    value: "\(Int(f.totalPower.rounded()))",
                                    caption: String(localized: "Total spectral power across all frequency bands."),
                                    accent: StrandPalette.metricCyan
                                )
                            }
                        }

                        // Poincaré / rhythm regularity
                        if let r = rhythm, r.sd1 != nil {
                            if hrvResult != nil || stressIndex != nil || freqHRV != nil {
                                Divider().background(StrandPalette.hairline)
                            }
                            Text("Poincaré").strandOverline()
                            LazyVGrid(
                                columns: [GridItem(.adaptive(minimum: 168), spacing: NoopMetrics.gap)],
                                alignment: .leading,
                                spacing: NoopMetrics.gap
                            ) {
                                StatTile(
                                    label: "SD1",
                                    value: r.sd1.map { String(format: "%.1f ms", $0) } ?? "—",
                                    caption: String(localized: "Short-axis variability (parasympathetic). Reflects beat-to-beat variation."),
                                    accent: StrandPalette.metricAmber
                                )
                                StatTile(
                                    label: "SD2",
                                    value: r.sd2.map { String(format: "%.1f ms", $0) } ?? "—",
                                    caption: String(localized: "Long-axis variability. Reflects overall R-R range."),
                                    accent: StrandPalette.metricAmber
                                )
                                StatTile(
                                    label: "SD1/SD2",
                                    value: r.sd1sd2.map { String(format: "%.2f", $0) } ?? "—",
                                    caption: String(localized: "Ratio of short to long-axis variability. Higher = more parasympathetic dominance."),
                                    accent: StrandPalette.metricAmber
                                )
                                StatTile(
                                    label: "Regularity",
                                    value: rhythmRegularityLabel(r.label),
                                    caption: String(localized: "Descriptive rhythm classification from the Poincaré cloud shape."),
                                    accent: StrandPalette.metricAmber
                                )
                            }
                            // Poincaré scatter plot
                            if !r.poincare.isEmpty {
                                poincarePlot(r)
                                    .padding(.top, NoopMetrics.space1)
                            }
                        }

                        Text("These are extra, on-demand HRV lenses computed from today's R-R intervals. They are informational and do not change your recovery or stress scores.")
                            .font(StrandFont.footnote)
                            .foregroundStyle(StrandPalette.textTertiary)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, NoopMetrics.space1)
                    }
                }
            }
        }
    }

    // MARK: - 4. HRV Trend with baseline bands and range selection

    /// All HRV trend points from `repo.days`, oldest→newest.
    private var allHrvPoints: [TrendPoint] {
        repo.days.compactMap { d in
            guard let v = d.avgHrv,
                  let dt = Self.dayParser.date(from: d.day) else { return nil }
            return TrendPoint(date: dt, value: v)
        }
    }

    /// HRV trend points filtered by the selected ExploreRange.
    private var hrvPoints: [TrendPoint] {
        let all = allHrvPoints
        guard let days = range.days else { return all }
        let cal = Calendar.current
        let cutoff = cal.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return all.filter { $0.date >= cutoff }
    }

    /// Single-color gradient for the HRV trend line (matches TrendsView's pattern).
    private var hrvGradient: Gradient {
        Gradient(stops: [
            .init(color: StrandPalette.metricPurple.opacity(0.55), location: 0.0),
            .init(color: StrandPalette.metricPurple, location: 1.0),
        ])
    }

    /// Y-domain for the trend chart: data range with padding, clamped to physiological bounds.
    private var trendYDomain: ClosedRange<Double> {
        let pts = hrvPoints
        guard !pts.isEmpty else { return 5...250 }
        let vals = pts.map(\.value)
        let lo = vals.min() ?? 5
        let hi = vals.max() ?? 250
        let pad = max((hi - lo) * 0.15, 5)
        return max(5, lo - pad)...min(250, hi + pad)
    }

    @ViewBuilder
    private var trendSection: some View {
        VStack(alignment: .leading, spacing: NoopMetrics.gap) {
            SectionHeader("HRV Trend",
                          overline: "Over time",
                          trailing: String(localized: "History"))

            // Range selector
            SegmentedPillControl(
                ExploreRange.allCases,
                selection: $range,
                label: { $0.label }
            )

            let pts = hrvPoints
            if pts.count < 2 {
                NoopCard {
                    VStack(spacing: NoopMetrics.space2) {
                        Text("Not enough data")
                            .font(StrandFont.title2)
                            .foregroundStyle(StrandPalette.textPrimary)
                        Text("At least 2 nights with HRV are needed to draw a trend.")
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
                            gradient: hrvGradient,
                            valueRange: 5...250,
                            showsArea: true,
                            height: NoopMetrics.chartHeight,
                            showsHover: true,
                            valueFormat: { String(Int($0.rounded())) },
                            accessibilityLabel: "HRV trend",
                            nowCapColor: StrandPalette.metricPurple,
                            yDomain: trendYDomain
                        )
                        // Baseline annotation
                        let base = hrvBaseline
                        if base.usable {
                            HStack(spacing: NoopMetrics.space2) {
                                Circle()
                                    .fill(StrandPalette.textTertiary)
                                    .frame(width: 7, height: 7)
                                Text("Baseline: \(Int(base.baseline.rounded())) ms (\(base.nValid) nights)")
                                    .font(StrandFont.caption)
                                    .foregroundStyle(StrandPalette.textSecondary)
                                Spacer(minLength: 0)
                                if let latest = pts.last {
                                    let delta = latest.value - base.baseline
                                    TrendChip(
                                        text: String(format: "%@%.0f ms", delta >= 0 ? "+" : "", delta),
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

    // MARK: - 5. HRV Distribution (7-day histogram)

    /// HRV values from the last 7 nights for the distribution histogram.
    private var last7HrvValues: [Double] {
        let cal = Calendar.current
        let cutoff = cal.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return allHrvPoints.filter { $0.date >= cutoff }.map(\.value)
    }

    @ViewBuilder
    private var distributionSection: some View {
        VStack(alignment: .leading, spacing: NoopMetrics.gap) {
            SectionHeader("7-Day Distribution",
                          overline: "Recent",
                          trailing: String(localized: "Histogram"))

            let vals = last7HrvValues
            if vals.count < 2 {
                NoopCard {
                    VStack(spacing: NoopMetrics.space2) {
                        Text("Not enough data")
                            .font(StrandFont.title2)
                            .foregroundStyle(StrandPalette.textPrimary)
                        Text("At least 2 nights of HRV are needed to show a distribution.")
                            .font(StrandFont.subhead)
                            .foregroundStyle(StrandPalette.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                NoopCard {
                    VStack(alignment: .leading, spacing: NoopMetrics.cardInnerSpacing) {
                        hrvHistogram(vals)
                        let mean = vals.reduce(0, +) / Double(vals.count)
                        let sorted = vals.sorted()
                        let median = sorted[sorted.count / 2]
                        let range = (sorted.first ?? 0)...(sorted.last ?? 0)
                        HStack(spacing: NoopMetrics.space4) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Mean").strandOverline()
                                Text("\(Int(mean.rounded())) ms")
                                    .font(StrandFont.number(18))
                                    .foregroundStyle(StrandPalette.textPrimary)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Median").strandOverline()
                                Text("\(Int(median.rounded())) ms")
                                    .font(StrandFont.number(18))
                                    .foregroundStyle(StrandPalette.textPrimary)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Range").strandOverline()
                                Text("\(Int(range.lowerBound))–\(Int(range.upperBound)) ms")
                                    .font(StrandFont.number(18))
                                    .foregroundStyle(StrandPalette.textPrimary)
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(.top, NoopMetrics.space1)
                    }
                }
            }
        }
    }

    /// Simple bar histogram of HRV values.
    @ViewBuilder
    private func hrvHistogram(_ values: [Double]) -> some View {
        let (buckets, maxCount) = computeBuckets(values)

        HStack(alignment: .bottom, spacing: 4) {
            ForEach(0..<buckets.count, id: \.self) { i in
                VStack(spacing: 2) {
                    Text("\(buckets[i])")
                        .font(StrandFont.caption)
                        .foregroundStyle(StrandPalette.textTertiary)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(StrandPalette.metricPurple.opacity(0.7))
                        .frame(height: CGFloat(buckets[i]) / CGFloat(maxCount) * 80)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 100, alignment: .bottom)
        .padding(.vertical, NoopMetrics.space1)
    }

    /// Compute histogram buckets for the HRV values array.
    private func computeBuckets(_ values: [Double]) -> (buckets: [Int], maxCount: Int) {
        guard !values.isEmpty else { return ([], 1) }
        let lo = values.min() ?? 0
        let hi = values.max() ?? 100
        let span = max(hi - lo, 1)
        let bucketCount = min(8, values.count)
        let bucketWidth = span / Double(bucketCount)
        var buckets = Array(repeating: 0, count: bucketCount)
        for v in values {
            let idx = min(Int((v - lo) / bucketWidth), bucketCount - 1)
            buckets[idx] += 1
        }
        return (buckets, buckets.max() ?? 1)
    }

    /// Poincaré scatter plot from R-R pairs.
    @ViewBuilder
    private func poincarePlot(_ r: RhythmScreener.WindowResult) -> some View {
        let points = r.poincare
        if points.isEmpty {
            EmptyView()
        } else {
            let allVals = points.flatMap { [$0.x, $0.y] }
            let lo = allVals.min() ?? 0
            let hi = allVals.max() ?? 1000
            let pad = max((hi - lo) * 0.1, 10)
            let domain = (lo - pad)...(hi + pad)
            let span = domain.upperBound - domain.lowerBound

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(StrandPalette.surfaceInset.opacity(0.5))
                    .frame(height: 160)

                // Identity line (SD1 = SD2)
                Path { p in
                    p.move(to: CGPoint(x: 12, y: 148))
                    p.addLine(to: CGPoint(x: 148, y: 12))
                }
                .stroke(StrandPalette.hairline, lineWidth: 0.5)
                .frame(width: 160, height: 160)

                // Scatter points
                ForEach(0..<min(points.count, 200), id: \.self) { i in
                    let pt = points[i]
                    let x = 12 + CGFloat((pt.x - domain.lowerBound) / span) * 136
                    let y = 148 - CGFloat((pt.y - domain.lowerBound) / span) * 136
                    Circle()
                        .fill(StrandPalette.metricAmber.opacity(0.6))
                        .frame(width: 3, height: 3)
                        .position(x: x, y: y)
                }
            }
            .frame(height: 160)
            .accessibilityLabel("Poincaré scatter plot of R-R intervals")
        }
    }

    // MARK: - Async load

    /// Read TODAY's banked R-R intervals and compute the advanced HRV readouts.
    /// Mirrors StressView's loadDaytime pattern — same data source, same engines.
    private func loadAdvancedReadouts() async {
        let cal = Calendar.current
        let startOfDay = cal.startOfDay(for: Date())
        let from = Int(startOfDay.timeIntervalSince1970)
        let to = Int(Date().timeIntervalSince1970)

        let rr = (try? await repo.storeHandle()?.rrIntervals(
            deviceId: repo.deviceId, from: from, to: to, limit: 200_000)) ?? []

        guard !rr.isEmpty else {
            hrvResult = nil
            stressIndex = nil
            freqHRV = nil
            rhythm = nil
            advancedLoaded = true
            return
        }

        hrvResult = HRVAnalyzer.analyze(rr)
        stressIndex = StressIndex.components(rr: rr)
        freqHRV = HRVFreqDomain.freqDomain(rr: rr)
        rhythm = RhythmScreener.screenWindow(.init(rr: rr, motionStill: true))
        advancedLoaded = true
    }

    /// Map RhythmRegularity enum cases to human-readable display strings.
    private func rhythmRegularityLabel(_ label: RhythmRegularity) -> String {
        switch label {
        case .steady:           return String(localized: "Steady")
        case .occasionalEctopy: return String(localized: "Occasional ectopy")
        case .varied:           return String(localized: "Varied")
        case .unreadable:       return String(localized: "Unreadable")
        }
    }
}
