import SwiftUI
import StrandAnalytics
import WhoopStore

// MARK: - Beta Today Feed
//
// Card-based vertical feed showing today's recovery, strain, sleep, live HR,
// streaks, and a coaching snippet. Visually distinct from the main app's TodayView.

extension @retroactive CachedSleepSession: Identifiable {
    public var id: Int { startTs }
}

struct BetaTodayFeed: View {
    @EnvironmentObject var model: AppModel
    @EnvironmentObject var live: LiveState
    @EnvironmentObject var repo: Repository
    @EnvironmentObject var betaCoach: BetaAICoachEngine
    @EnvironmentObject var profile: ProfileStore

    @State private var showBreathing = false
    @State private var showSettings = false
    @State private var sleepDetailSession: CachedSleepSession?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Header
                    headerCard

                    // Recovery + Strain rings
                    ringsCard

                    // Sleep summary
                    if let day = repo.days.last, day.totalSleepMin != nil {
                        if let session = latestSleepSession {
                            Button {
                                sleepDetailSession = session
                            } label: {
                                sleepCard(day: day)
                            }
                            .buttonStyle(.plain)
                        } else {
                            sleepCard(day: day)
                        }
                    }

                    // Live HR (if connected)
                    if live.connected {
                        liveHRCard
                    }

                    // Streak card
                    streakCard

                    // AI Coach snippet
                    coachSnippetCard

                    // Breathing exercise shortcut
                    Button {
                        showBreathing = true
                    } label: {
                        breathingCard
                    }
                    .buttonStyle(.plain)

                    // Achievements preview
                    achievementsPreview
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .background(BetaPalette.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("NOOP Beta")
                        .font(BetaFont.headline())
                        .foregroundColor(BetaPalette.textPrimary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18))
                            .foregroundColor(BetaPalette.textSecondary)
                    }
                }
            }
            .sheet(isPresented: $showBreathing) {
                BetaBreathingView()
            }
            .sheet(isPresented: $showSettings) {
                BetaSettingsView()
            }
            .sheet(item: $sleepDetailSession) { session in
                BetaSleepDetailView(session: session)
            }
        }
    }

    // MARK: - Cards

    private var headerCard: some View {
        BetaCard(gradient: BetaPalette.heroGradient) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(greeting)
                        .font(BetaFont.title())
                        .foregroundColor(.white)
                    Text(dateString)
                        .font(BetaFont.subheadline())
                        .foregroundColor(.white.opacity(0.8))
                }
                Spacer()
                if live.connected {
                    BetaPill(text: "Connected", color: BetaPalette.tertiary, icon: "antenna.radiowaves.left.and.right")
                } else {
                    BetaPill(text: "Offline", color: BetaPalette.textTertiary, icon: "antenna.radiowaves.left.and.right.slash")
                }
            }
        }
    }

    private var ringsCard: some View {
        BetaCard {
            HStack(spacing: 16) {
                if let day = repo.days.last {
                    BetaMetricRing(
                        value: (day.recovery ?? 0) / 100,
                        color: BetaPalette.recovery,
                        label: "Recovery",
                        displayValue: "\(Int((day.recovery ?? 0).rounded()))"
                    )
                    BetaMetricRing(
                        value: (day.strain ?? 0) / 100,
                        color: BetaPalette.strain,
                        label: "Strain",
                        displayValue: "\(Int((day.strain ?? 0).rounded()))"
                    )
                    BetaMetricRing(
                        value: sleepEfficiency(day),
                        color: BetaPalette.sleep,
                        label: "Sleep",
                        displayValue: sleepDisplay(day)
                    )
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "hourglass")
                            .font(.system(size: 40))
                            .foregroundColor(BetaPalette.textTertiary)
                        Text("No data yet")
                            .font(BetaFont.subheadline())
                            .foregroundColor(BetaPalette.textSecondary)
                        Text("Sync your strap to see your scores")
                            .font(BetaFont.caption())
                            .foregroundColor(BetaPalette.textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                }
            }
        }
    }

    private func sleepCard(day: DailyMetric) -> some View {
        BetaCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "bed.double.fill")
                        .foregroundColor(BetaPalette.sleep)
                    Text("Last Night's Sleep")
                        .font(BetaFont.headline())
                        .foregroundColor(BetaPalette.textPrimary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(BetaPalette.textTertiary)
                }

                let hours = (day.totalSleepMin ?? 0) / 60.0
                Text(String(format: "%.1f", hours))
                    .font(BetaFont.metric())
                    .foregroundColor(BetaPalette.textPrimary)
                + Text("h")
                    .font(BetaFont.title2())
                    .foregroundColor(BetaPalette.textSecondary)

                if let deep = day.deepMin, let rem = day.remMin {
                    HStack(spacing: 16) {
                        sleepStageBar(label: "Deep", minutes: deep, color: BetaPalette.secondary, total: day.totalSleepMin ?? 1)
                        sleepStageBar(label: "REM", minutes: rem, color: BetaPalette.tertiary, total: day.totalSleepMin ?? 1)
                    }
                }
            }
        }
    }

    private func sleepStageBar(label: String, minutes: Double, color: Color, total: Double) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(BetaFont.caption())
                .foregroundColor(BetaPalette.textSecondary)
            BetaProgressBar(value: minutes / max(total, 1), color: color)
            Text("\(Int(minutes / 60.0))h \(Int(minutes) % 60)m")
                .font(BetaFont.caption())
                .foregroundColor(BetaPalette.textTertiary)
        }
    }

    private var liveHRCard: some View {
        BetaCard {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Live Heart Rate")
                        .font(BetaFont.subheadline())
                        .foregroundColor(BetaPalette.textSecondary)
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(model.bpm ?? live.heartRate ?? 0)")
                            .font(BetaFont.metric())
                            .foregroundColor(BetaPalette.textPrimary)
                        Text("bpm")
                            .font(BetaFont.body())
                            .foregroundColor(BetaPalette.textSecondary)
                    }
                }
                Spacer()
                Image(systemName: "heart.fill")
                    .font(.system(size: 40))
                    .foregroundColor(BetaPalette.strain)
                    .symbolEffect(.pulse)
            }
        }
    }

    private var streakCard: some View {
        BetaCard {
            HStack {
                Image(systemName: "flame.fill")
                    .font(.system(size: 36))
                    .foregroundColor(BetaPalette.warning)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recovery Streak")
                        .font(BetaFont.subheadline())
                        .foregroundColor(BetaPalette.textSecondary)
                    Text("\(BetaStreakEngine.currentStreak(days: repo.days)) days")
                        .font(BetaFont.title2())
                        .foregroundColor(BetaPalette.textPrimary)
                }
                Spacer()
                Text(BetaStreakEngine.streakEmoji(days: repo.days))
                    .font(.system(size: 32))
            }
        }
    }

    private var coachSnippetCard: some View {
        BetaCard(gradient: LinearGradient(
            colors: [BetaPalette.secondary.opacity(0.3), BetaPalette.cardBackground],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "brain.head.profile")
                        .foregroundColor(BetaPalette.secondary)
                    Text("Coach Brief")
                        .font(BetaFont.headline())
                        .foregroundColor(BetaPalette.textPrimary)
                    Spacer()
                    BetaPill(text: "Free AI", color: BetaPalette.tertiary, icon: "sparkles")
                }

                if betaCoach.messages.isEmpty {
                    Text("Tap to get your daily coaching brief — powered by free AI, no API key needed.")
                        .font(BetaFont.body())
                        .foregroundColor(BetaPalette.textSecondary)
                } else if let last = betaCoach.messages.last {
                    Text(last.text.prefix(200) + (last.text.count > 200 ? "…" : ""))
                        .font(BetaFont.body())
                        .foregroundColor(BetaPalette.textSecondary)
                        .lineLimit(5)
                }
            }
        }
    }

    private var breathingCard: some View {
        BetaCard {
            HStack {
                Image(systemName: "wind")
                    .font(.system(size: 32))
                    .foregroundColor(BetaPalette.tertiary)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Breathe")
                        .font(BetaFont.headline())
                        .foregroundColor(BetaPalette.textPrimary)
                    Text("60-second box breathing to downshift your nervous system")
                        .font(BetaFont.caption())
                        .foregroundColor(BetaPalette.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(BetaPalette.textTertiary)
            }
        }
    }

    private var achievementsPreview: some View {
        BetaCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(BetaPalette.warning)
                    Text("Achievements")
                        .font(BetaFont.headline())
                        .foregroundColor(BetaPalette.textPrimary)
                    Spacer()
                }
                HStack(spacing: 12) {
                    ForEach(BetaAchievements.recent(days: repo.days).prefix(4), id: \.id) { achievement in
                        VStack(spacing: 4) {
                            Image(systemName: achievement.icon)
                                .font(.system(size: 24))
                                .foregroundColor(achievement.color)
                            Text(achievement.title)
                                .font(.system(size: 9, weight: .medium, design: .rounded))
                                .foregroundColor(BetaPalette.textSecondary)
                                .lineLimit(1)
                        }
                        .frame(width: 60)
                    }
                }
            }
        }
    }

    // MARK: - Helpers

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default:      return "Good night"
        }
    }

    private var dateString: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMM d"
        return f.string(from: Date())
    }

    private func sleepEfficiency(_ day: DailyMetric) -> Double {
        guard let mins = day.totalSleepMin, mins > 0 else { return 0 }
        return min(1, mins / (8 * 60))
    }

    private func sleepDisplay(_ day: DailyMetric) -> String {
        let hours = (day.totalSleepMin ?? 0) / 60.0
        return String(format: "%.1f", hours)
    }

    private var latestSleepSession: CachedSleepSession? {
        guard let day = repo.days.last else { return nil }
        let offsetSec = TimeZone.current.secondsFromGMT()
        let dayKey = day.day
        return repo.sleeps.last { session in
            let sessionDayKey = betaDayKey(session.endTs, offsetSec: offsetSec)
            return sessionDayKey == dayKey
        }
    }

    private func betaDayKey(_ unix: Int, offsetSec: Int) -> String {
        let day = (unix + offsetSec) / 86_400
        let date = Date(timeIntervalSince1970: TimeInterval(day * 86_400))
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(identifier: "UTC")
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }
}
