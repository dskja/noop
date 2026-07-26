import SwiftUI
import StrandDesign
import WhoopStore

// MARK: - Beta Sleep Detail View
//
// Shows a hypnogram + per-stage breakdown for a single sleep session.
// Uses the shared Hypnogram component from StrandDesign, styled with BetaPalette.

struct BetaSleepDetailView: View {
    let session: CachedSleepSession
    @EnvironmentObject var repo: Repository
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    summaryCard
                    hypnogramCard
                    stageBreakdownCard
                    vitalsCard
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .background(BetaPalette.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Sleep Detail")
                        .font(BetaFont.headline())
                        .foregroundColor(BetaPalette.textPrimary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(BetaFont.subheadline())
                        .foregroundColor(BetaPalette.primary)
                }
            }
        }
    }

    // MARK: - Summary Card

    private var summaryCard: some View {
        BetaCard(gradient: LinearGradient(
            colors: [BetaPalette.sleep.opacity(0.3), BetaPalette.cardBackground],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "bed.double.fill")
                        .foregroundColor(BetaPalette.sleep)
                    Text("Sleep Summary")
                        .font(BetaFont.headline())
                        .foregroundColor(BetaPalette.textPrimary)
                    Spacer()
                }

                let totalMin = decodedStages?.asleep ?? Double(session.endTs - session.effectiveStartTs) / 60.0
                let hours = totalMin / 60.0

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.1f", hours))
                        .font(BetaFont.metric())
                        .foregroundColor(BetaPalette.textPrimary)
                    Text("h asleep")
                        .font(BetaFont.body())
                        .foregroundColor(BetaPalette.textSecondary)
                }

                HStack(spacing: 16) {
                    if let eff = session.efficiency {
                        vitalPill("Efficiency", String(format: "%.0f%%", eff))
                    }
                    vitalPill("In Bed", timeString(session.endTs - session.effectiveStartTs))
                    if let rhr = session.restingHr {
                        vitalPill("Resting HR", "\(rhr) bpm")
                    }
                    if let hrv = session.avgHrv {
                        vitalPill("HRV", String(format: "%.0f", hrv))
                    }
                }
            }
        }
    }

    // MARK: - Hypnogram Card

    private var hypnogramCard: some View {
        BetaCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundColor(BetaPalette.sleep)
                    Text("Hypnogram")
                        .font(BetaFont.headline())
                        .foregroundColor(BetaPalette.textPrimary)
                    Spacer()
                }

                if let intervals = decodedIntervals, intervals.count >= 2 {
                    Hypnogram(
                        intervals: intervals,
                        height: 180,
                        showsStageAxis: true,
                        showsHover: false,
                        nightStart: onsetDate,
                        showsTimeAxis: true
                    )
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "moon.zzz")
                            .font(.system(size: 36))
                            .foregroundColor(BetaPalette.textTertiary)
                        Text("No stage timeline available")
                            .font(BetaFont.subheadline())
                            .foregroundColor(BetaPalette.textSecondary)
                        Text("This sleep session doesn't have per-epoch staging data.")
                            .font(BetaFont.caption())
                            .foregroundColor(BetaPalette.textTertiary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                }
            }
        }
    }

    // MARK: - Stage Breakdown Card

    private var stageBreakdownCard: some View {
        BetaCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(BetaPalette.secondary)
                    Text("Stage Breakdown")
                        .font(BetaFont.headline())
                        .foregroundColor(BetaPalette.textPrimary)
                    Spacer()
                }

                if let stages = decodedStages {
                    let total = max(stages.total, 1)
                    stageRow("Deep", minutes: stages.deep, color: BetaPalette.secondary, total: total)
                    stageRow("REM", minutes: stages.rem, color: BetaPalette.tertiary, total: total)
                    stageRow("Light", minutes: stages.light, color: BetaPalette.sleep, total: total)
                    stageRow("Awake", minutes: stages.awake, color: BetaPalette.textTertiary, total: total)
                } else {
                    Text("No stage data for this session.")
                        .font(BetaFont.body())
                        .foregroundColor(BetaPalette.textSecondary)
                }
            }
        }
    }

    // MARK: - Vitals Card

    private var vitalsCard: some View {
        BetaCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Image(systemName: "heart.text.square")
                        .foregroundColor(BetaPalette.strain)
                    Text(" Overnight Vitals")
                        .font(BetaFont.headline())
                        .foregroundColor(BetaPalette.textPrimary)
                    Spacer()
                }

                if let day = matchingDay {
                    if let spo2 = day.spo2Pct {
                        infoRow("SpO₂", String(format: "%.1f%%", spo2))
                    }
                    if let temp = day.skinTempDevC {
                        infoRow("Skin Temp", String(format: "%+.1f°C", temp))
                    }
                    if let resp = day.respRateBpm {
                        infoRow("Respiration", String(format: "%.1f bpm", resp))
                    }
                    if let dist = day.disturbances {
                        infoRow("Disturbances", "\(dist)")
                    }
                }

                if let rhr = session.restingHr {
                    infoRow("Resting HR", "\(rhr) bpm")
                }
                if let hrv = session.avgHrv {
                    infoRow("HRV (RMSSD)", String(format: "%.0f ms", hrv))
                }
            }
        }
    }

    // MARK: - Helpers

    private struct BetaStages {
        var awake: Double
        var light: Double
        var deep: Double
        var rem: Double
        var total: Double { awake + light + deep + rem }
        var asleep: Double { light + deep + rem }
    }

    private var decodedStages: BetaStages? {
        guard let json = session.stagesJSON,
              let data = json.data(using: .utf8) else { return nil }

        // Try segment array format first (computed): [{"start":epoch,"end":epoch,"stage":"wake"|"light"|"deep"|"rem"}]
        if let arr = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]], !arr.isEmpty {
            var s = BetaStages(awake: 0, light: 0, deep: 0, rem: 0)
            for seg in arr {
                guard let start = (seg["start"] as? NSNumber)?.intValue,
                      let end = (seg["end"] as? NSNumber)?.intValue, end > start,
                      let name = seg["stage"] as? String else { continue }
                let minutes = Double(end - start) / 60.0
                switch name {
                case "wake", "awake": s.awake += minutes
                case "light": s.light += minutes
                case "deep":  s.deep += minutes
                case "rem":   s.rem += minutes
                default: continue
                }
            }
            return s.total > 0 ? s : nil
        }

        // Try minute dict format (imported): {"light":N,"deep":N,"rem":N,"awake":N}
        if let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            func val(_ key: String) -> Double {
                if let n = dict[key] as? NSNumber { return n.doubleValue }
                if let d = dict[key] as? Double { return d }
                if let i = dict[key] as? Int { return Double(i) }
                return 0
            }
            let s = BetaStages(awake: val("awake"), light: val("light"),
                               deep: val("deep"), rem: val("rem"))
            return s.total > 0 ? s : nil
        }

        return nil
    }

    private var decodedIntervals: [SleepInterval]? {
        guard let json = session.stagesJSON,
              let data = json.data(using: .utf8),
              let arr = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]],
              !arr.isEmpty else { return nil }

        let sessionStart = session.effectiveStartTs
        var intervals: [SleepInterval] = []
        for seg in arr {
            guard let start = (seg["start"] as? NSNumber)?.intValue,
                  let end = (seg["end"] as? NSNumber)?.intValue, end > start,
                  let name = seg["stage"] as? String else { continue }
            let stage: SleepStage
            switch name {
            case "wake", "awake": stage = .awake
            case "light": stage = .light
            case "deep":  stage = .deep
            case "rem":   stage = .rem
            default: continue
            }
            intervals.append(SleepInterval(
                stage: stage,
                start: TimeInterval(start - sessionStart),
                end: TimeInterval(end - sessionStart)))
        }
        return intervals.count >= 2 ? intervals : nil
    }

    private var onsetDate: Date {
        Date(timeIntervalSince1970: TimeInterval(session.effectiveStartTs))
    }

    private var matchingDay: DailyMetric? {
        let offsetSec = TimeZone.current.secondsFromGMT(for: onsetDate)
        let dayKey = AnalyticsEngine_dayString(session.endTs, offsetSec: offsetSec)
        return repo.days.last { $0.day == dayKey }
    }

    private func stageRow(_ label: String, minutes: Double, color: Color, total: Double) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(BetaFont.subheadline())
                    .foregroundColor(BetaPalette.textSecondary)
                Spacer()
                Text(timeString(Int(minutes * 60)))
                    .font(BetaFont.subheadline())
                    .foregroundColor(BetaPalette.textPrimary)
                Text(String(format: "%.0f%%", minutes / total * 100))
                    .font(BetaFont.caption())
                    .foregroundColor(BetaPalette.textTertiary)
            }
            BetaProgressBar(value: minutes / total, color: color)
        }
    }

    private func vitalPill(_ label: String, _ value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(BetaFont.subheadline())
                .foregroundColor(BetaPalette.textPrimary)
            Text(label)
                .font(.system(size: 10, weight: .regular, design: .rounded))
                .foregroundColor(BetaPalette.textTertiary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(BetaPalette.cardBackgroundElevated)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func infoRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(BetaFont.subheadline())
                .foregroundColor(BetaPalette.textSecondary)
            Spacer()
            Text(value)
                .font(BetaFont.subheadline())
                .foregroundColor(BetaPalette.textPrimary)
        }
    }

    private func timeString(_ seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        if h > 0 {
            return "\(h)h \(m)m"
        }
        return "\(m)m"
    }
}

// MARK: - Day-key helper (mirrors AnalyticsEngine.dayString)
private func AnalyticsEngine_dayString(_ unix: Int, offsetSec: Int) -> String {
    let day = (unix + offsetSec) / 86_400
    let date = Date(timeIntervalSince1970: TimeInterval(day * 86_400))
    let f = DateFormatter()
    f.locale = Locale(identifier: "en_US_POSIX")
    f.timeZone = TimeZone(identifier: "UTC")
    f.dateFormat = "yyyy-MM-dd"
    return f.string(from: date)
}
