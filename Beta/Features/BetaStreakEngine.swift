import Foundation
import SwiftUI
import StrandAnalytics
import WhoopStore

// MARK: - Beta Streak Engine
//
// Tracks consecutive days with recovery data above a threshold.
// Pure functions, no state — all derived from the Repository's day array.

enum BetaStreakEngine {
    /// Minimum recovery score to count as a "streak day".
    private static let minRecovery: Double = 1.0  // any scored day counts

    /// Current streak of consecutive days with recovery data, counting back from today.
    static func currentStreak(days: [DailyMetric]) -> Int {
        guard !days.isEmpty else { return 0 }
        var streak = 0
        for day in days.reversed() {
            if let r = day.recovery, r >= minRecovery {
                streak += 1
            } else {
                break
            }
        }
        return streak
    }

    /// Best streak ever achieved.
    static func bestStreak(days: [DailyMetric]) -> Int {
        guard !days.isEmpty else { return 0 }
        var best = 0
        var current = 0
        for day in days {
            if let r = day.recovery, r >= minRecovery {
                current += 1
                best = max(best, current)
            } else {
                current = 0
            }
        }
        return best
    }

    /// Emoji representation for the current streak level.
    static func streakEmoji(days: [DailyMetric]) -> String {
        let streak = currentStreak(days: days)
        switch streak {
        case 0..<3:   return "🌱"
        case 3..<7:   return "🔥"
        case 7..<14:  return "⚡️"
        case 14..<30: return "🚀"
        case 30...:   return "👑"
        default:      return "🌱"
        }
    }
}

// MARK: - Beta Achievements
//
// Unlocks based on the user's historical data. Pure functions.

struct BetaAchievement: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let description: String
}

enum BetaAchievements {
    /// All achievements the user has unlocked based on their data.
    static func all(days: [DailyMetric]) -> [BetaAchievement] {
        var unlocked: [BetaAchievement] = []

        // First sync
        if !days.isEmpty {
            unlocked.append(BetaAchievement(
                title: "First Sync",
                icon: "antenna.radiowaves.left.and.right",
                color: BetaPalette.primary,
                description: "Connected your strap for the first time"
            ))
        }

        // 3-day streak
        if BetaStreakEngine.currentStreak(days: days) >= 3 {
            unlocked.append(BetaAchievement(
                title: "On a Roll",
                icon: "flame.fill",
                color: BetaPalette.warning,
                description: "3-day recovery streak"
            ))
        }

        // 7-day streak
        if BetaStreakEngine.currentStreak(days: days) >= 7 {
            unlocked.append(BetaAchievement(
                title: "Week Warrior",
                icon: "shield.fill",
                color: BetaPalette.tertiary,
                description: "7-day recovery streak"
            ))
        }

        // 14-day streak
        if BetaStreakEngine.currentStreak(days: days) >= 14 {
            unlocked.append(BetaAchievement(
                title: "Fortnight Force",
                icon: "bolt.fill",
                color: BetaPalette.secondary,
                description: "14-day recovery streak"
            ))
        }

        // 30-day streak
        if BetaStreakEngine.currentStreak(days: days) >= 30 {
            unlocked.append(BetaAchievement(
                title: "Unstoppable",
                icon: "crown.fill",
                color: BetaPalette.warning,
                description: "30-day recovery streak"
            ))
        }

        // Recovery > 80
        if let best = days.compactMap({ $0.recovery }).max(), best >= 80 {
            unlocked.append(BetaAchievement(
                title: "Peak Recovery",
                icon: "heart.fill",
                color: BetaPalette.recovery,
                description: "Recovery score above 80"
            ))
        }

        // Sleep > 8h
        if let bestSleep = days.compactMap({ $0.totalSleepMin }).max(), bestSleep / 60.0 >= 8.0 {
            unlocked.append(BetaAchievement(
                title: "Sleep Champion",
                icon: "bed.double.fill",
                color: BetaPalette.sleep,
                description: "Slept 8+ hours"
            ))
        }

        // HRV > 50ms
        if let bestHRV = days.compactMap({ $0.avgHrv }).max(), bestHRV >= 50 {
            unlocked.append(BetaAchievement(
                title: "Zen Master",
                icon: "leaf.fill",
                color: BetaPalette.tertiary,
                description: "HRV above 50ms"
            ))
        }

        // Strain > 80
        if let bestStrain = days.compactMap({ $0.strain }).max(), bestStrain >= 80 {
            unlocked.append(BetaAchievement(
                title: "Pushed Hard",
                icon: "figure.highintensity.intervaltraining",
                color: BetaPalette.strain,
                description: "Strain score above 80"
            ))
        }

        // 10 days of data
        if days.count >= 10 {
            unlocked.append(BetaAchievement(
                title: "Getting Serious",
                icon: "chart.bar.fill",
                color: BetaPalette.primary,
                description: "10 days of data"
            ))
        }

        // 30 days of data
        if days.count >= 30 {
            unlocked.append(BetaAchievement(
                title: "Data Devotee",
                icon: "calendar.badge.checkmark",
                color: BetaPalette.secondary,
                description: "30 days of data"
            ))
        }

        return unlocked
    }

    /// Most recent achievements (for the Today feed preview).
    static func recent(days: [DailyMetric]) -> [BetaAchievement] {
        all(days: days).suffix(4).map { $0 }
    }
}
