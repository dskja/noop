import SwiftUI
import StrandAnalytics
import WhoopStore

// MARK: - Beta Insights View
//
// Shows 7-day and 30-day trends for recovery, strain, sleep, HRV, and RHR
// with simple sparkline charts. Also surfaces personal patterns and achievements.

struct BetaInsightsView: View {
    @EnvironmentObject var repo: Repository
    @EnvironmentObject var intelligence: IntelligenceEngine

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // 7-day trend cards
                    BetaCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("7-Day Trends")
                                .font(BetaFont.title2())
                                .foregroundColor(BetaPalette.textPrimary)

                            trendRow(label: "Recovery", values: last7Values { $0.recovery }, color: BetaPalette.recovery, unit: "")
                            trendRow(label: "Strain", values: last7Values { $0.strain }, color: BetaPalette.strain, unit: "")
                            trendRow(label: "Sleep", values: last7Values { d in d.totalSleepMin.map { $0 / 60.0 } }, color: BetaPalette.sleep, unit: "h")
                            trendRow(label: "HRV", values: last7Values { $0.avgHrv }, color: BetaPalette.secondary, unit: "ms")
                            trendRow(label: "RHR", values: last7Values { $0.restingHr.map { Double($0) } }, color: BetaPalette.warning, unit: "bpm")
                        }
                    }

                    // Weekly summary
                    weeklySummaryCard

                    // Achievements
                    achievementsCard

                    // Personal records
                    recordsCard
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .background(BetaPalette.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Insights")
                        .font(BetaFont.headline())
                        .foregroundColor(BetaPalette.textPrimary)
                }
            }
        }
    }

    // MARK: - Trend row

    private func trendRow(label: String, values: [Double?], color: Color, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(BetaFont.subheadline())
                    .foregroundColor(BetaPalette.textSecondary)
                Spacer()
                if let avg = average(values) {
                    Text("avg \(String(format: unit == "h" ? "%.1f" : "%.0f", avg))\(unit)")
                        .font(BetaFont.caption())
                        .foregroundColor(BetaPalette.textTertiary)
                }
            }
            SparklineView(values: values.compactMap { $0 }, color: color)
                .frame(height: 40)
        }
    }

    // MARK: - Weekly summary

    private var weeklySummaryCard: some View {
        BetaCard(gradient: LinearGradient(
            colors: [BetaPalette.primary.opacity(0.15), BetaPalette.cardBackground],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )) {
            VStack(alignment: .leading, spacing: 12) {
                Text("This Week vs Last Week")
                    .font(BetaFont.title2())
                    .foregroundColor(BetaPalette.textPrimary)

                let thisWeek = lastNDays(7)
                let lastWeek = daysInRange(7..<14)

                comparisonRow(label: "Avg Recovery", thisWeek: average(thisWeek.compactMap { $0.recovery }), lastWeek: average(lastWeek.compactMap { $0.recovery }), higherIsBetter: true)
                comparisonRow(label: "Avg Strain", thisWeek: average(thisWeek.compactMap { $0.strain }), lastWeek: average(lastWeek.compactMap { $0.strain }), higherIsBetter: nil)
                comparisonRow(label: "Avg Sleep", thisWeek: average(thisWeek.compactMap { d in d.totalSleepMin.map { $0 / 60.0 } }), lastWeek: average(lastWeek.compactMap { d in d.totalSleepMin.map { $0 / 60.0 } }), higherIsBetter: true)
                comparisonRow(label: "Avg HRV", thisWeek: average(thisWeek.compactMap { $0.avgHrv }), lastWeek: average(lastWeek.compactMap { $0.avgHrv }), higherIsBetter: true)
            }
        }
    }

    private func comparisonRow(label: String, thisWeek: Double?, lastWeek: Double?, higherIsBetter: Bool?) -> some View {
        HStack {
            Text(label)
                .font(BetaFont.subheadline())
                .foregroundColor(BetaPalette.textSecondary)
            Spacer()
            if let tw = thisWeek, let lw = lastWeek {
                let delta = tw - lw
                let arrow = delta > 0 ? "↑" : (delta < 0 ? "↓" : "→")
                let color: Color = {
                    guard let hib = higherIsBetter else { return BetaPalette.textSecondary }
                    return (delta > 0 && hib) || (delta < 0 && !hib) ? BetaPalette.tertiary : BetaPalette.danger
                }()
                Text("\(String(format: "%.1f", tw)) \(arrow) \(String(format: "%.1f", delta))")
                    .font(BetaFont.caption())
                    .foregroundColor(color)
            } else {
                Text("—")
                    .font(BetaFont.caption())
                    .foregroundColor(BetaPalette.textTertiary)
            }
        }
    }

    // MARK: - Achievements card

    private var achievementsCard: some View {
        BetaCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(BetaPalette.warning)
                    Text("Achievements")
                        .font(BetaFont.title2())
                        .foregroundColor(BetaPalette.textPrimary)
                }
                let all = BetaAchievements.all(days: repo.days)
                if all.isEmpty {
                    Text("Sync your device to start unlocking achievements!")
                        .font(BetaFont.body())
                        .foregroundColor(BetaPalette.textSecondary)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(all, id: \.id) { a in
                            VStack(spacing: 6) {
                                Image(systemName: a.icon)
                                    .font(.system(size: 28))
                                    .foregroundColor(a.color)
                                Text(a.title)
                                    .font(.system(size: 10, weight: .medium, design: .rounded))
                                    .foregroundColor(BetaPalette.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Records card

    private var recordsCard: some View {
        BetaCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "medal.fill")
                        .foregroundColor(BetaPalette.primary)
                    Text("Personal Records")
                        .font(BetaFont.title2())
                        .foregroundColor(BetaPalette.textPrimary)
                }

                let days = repo.days
                let bestRecovery = days.compactMap { $0.recovery }.max()
                let bestSleep = days.compactMap { $0.totalSleepMin }.max()
                let bestHRV = days.compactMap { $0.avgHrv }.max()
                let bestStrain = days.compactMap { $0.strain }.max()

                recordRow(label: "Best Recovery", value: bestRecovery.map { "\(Int($0.rounded()))" } ?? "—")
                recordRow(label: "Longest Sleep", value: bestSleep.map { String(format: "%.1f h", $0 / 60.0) } ?? "—")
                recordRow(label: "Highest HRV", value: bestHRV.map { "\(Int($0)) ms" } ?? "—")
                recordRow(label: "Highest Strain", value: bestStrain.map { "\(Int($0.rounded()))" } ?? "—")
            }
        }
    }

    private func recordRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(BetaFont.subheadline())
                .foregroundColor(BetaPalette.textSecondary)
            Spacer()
            Text(value)
                .font(BetaFont.body())
                .foregroundColor(BetaPalette.textPrimary)
        }
    }

    // MARK: - Data helpers

    private func last7Values<T: Numeric>(_ extract: (DailyMetric) -> T?) -> [Double?] {
        lastNDays(7).map { d in
            extract(d).map { Double($0) }
        }
    }

    private func lastNDays(_ n: Int) -> [DailyMetric] {
        Array(repo.days.suffix(n))
    }

    private func daysInRange(_ range: Range<Int>) -> [DailyMetric] {
        let all = repo.days
        guard all.count >= range.upperBound else { return [] }
        return Array(all[all.count - range.upperBound ..< all.count - range.lowerBound])
    }

    private func average(_ values: [Double?]) -> Double? {
        let compact = values.compactMap { $0 }
        guard !compact.isEmpty else { return nil }
        return compact.reduce(0, +) / Double(compact.count)
    }
}

// MARK: - Sparkline

struct SparklineView: View {
    let values: [Double]
    let color: Color

    var body: some View {
        GeometryReader { geo in
            if values.count < 2 {
                Text("Not enough data")
                    .font(BetaFont.caption())
                    .foregroundColor(BetaPalette.textTertiary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                let minV = values.min() ?? 0
                let maxV = values.max() ?? 1
                let range = max(maxV - minV, 1)
                let stepX = geo.size.width / CGFloat(values.count - 1)

                Path { path in
                    for (i, v) in values.enumerated() {
                        let x = CGFloat(i) * stepX
                        let y = geo.size.height - CGFloat((v - minV) / range) * geo.size.height
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round))

                Path { path in
                    for (i, v) in values.enumerated() {
                        let x = CGFloat(i) * stepX
                        let y = geo.size.height - CGFloat((v - minV) / range) * geo.size.height
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: geo.size.height))
                            path.addLine(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                        if i == values.count - 1 {
                            path.addLine(to: CGPoint(x: x, y: geo.size.height))
                        }
                    }
                }
                .fill(color.opacity(0.1))
            }
        }
    }
}
