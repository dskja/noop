import SwiftUI

// MARK: - Beta Goals View
//
// Goal tracking with daily targets for sleep, recovery, strain, and movement.
// Shows progress bars and streaks for each goal.

struct BetaGoalsView: View {
    @EnvironmentObject var repo: Repository
    @EnvironmentObject var profile: ProfileStore
    @AppStorage("beta.goal.sleepHours") private var sleepGoalHours = 7.5
    @AppStorage("beta.goal.minRecovery") private var minRecovery = 50.0
    @AppStorage("beta.goal.weeklyStrain") private var weeklyStrainTarget = 250.0
    @AppStorage("beta.goal.dailySteps") private var dailyStepsTarget = 8000.0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Daily goals
                    BetaCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Daily Goals")
                                .font(BetaFont.title2())
                                .foregroundColor(BetaPalette.textPrimary)

                            goalRow(
                                icon: "bed.double.fill",
                                color: BetaPalette.sleep,
                                label: "Sleep",
                                current: currentSleepHours,
                                target: sleepGoalHours,
                                unit: "h",
                                progress: currentSleepHours / sleepGoalHours
                            )
                            goalRow(
                                icon: "heart.fill",
                                color: BetaPalette.recovery,
                                label: "Recovery",
                                current: currentRecovery,
                                target: 100,
                                unit: "",
                                progress: currentRecovery / 100
                            )
                            goalRow(
                                icon: "figure.walk",
                                color: BetaPalette.tertiary,
                                label: "Steps",
                                current: Double(currentSteps),
                                target: Double(dailyStepsTarget),
                                unit: "",
                                progress: Double(currentSteps) / Double(dailyStepsTarget)
                            )
                        }
                    }

                    // Weekly strain goal
                    BetaCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Weekly Strain Target")
                                .font(BetaFont.title2())
                                .foregroundColor(BetaPalette.textPrimary)
                            HStack {
                                BetaMetricRing(
                                    value: weeklyStrainProgress,
                                    color: BetaPalette.strain,
                                    label: "This Week",
                                    displayValue: "\(Int(weeklyStrainSum.rounded()))",
                                    size: 100
                                )
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Target: \(Int(weeklyStrainTarget))/week")
                                        .font(BetaFont.subheadline())
                                        .foregroundColor(BetaPalette.textSecondary)
                                    Text(weeklyStrainProgress >= 1 ? "Goal smashed!" : "\(Int(((weeklyStrainTarget - weeklyStrainSum)).rounded())) to go")
                                        .font(BetaFont.body())
                                        .foregroundColor(weeklyStrainProgress >= 1 ? BetaPalette.tertiary : BetaPalette.textPrimary)
                                }
                                Spacer()
                            }
                        }
                    }

                    // Goal settings
                    BetaCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Adjust Targets")
                                .font(BetaFont.title2())
                                .foregroundColor(BetaPalette.textPrimary)

                            sliderRow(label: "Sleep goal", value: $sleepGoalHours, range: 5...10, step: 0.5, unit: "h")
                            sliderRow(label: "Min recovery", value: $minRecovery, range: 0...100, step: 5, unit: "")
                            sliderRow(label: "Weekly strain", value: $weeklyStrainTarget, range: 50...500, step: 25, unit: "")
                            sliderRow(label: "Daily steps", value: $dailyStepsTarget, range: 2000...20000, step: 500, unit: "")
                        }
                    }

                    // Streak summary
                    BetaCard(gradient: LinearGradient(
                        colors: [BetaPalette.warning.opacity(0.2), BetaPalette.cardBackground],
                        startPoint: .top,
                        endPoint: .bottom
                    )) {
                        VStack(spacing: 12) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 40))
                                .foregroundColor(BetaPalette.warning)
                            Text("\(BetaStreakEngine.currentStreak(days: repo.days))-day recovery streak")
                                .font(BetaFont.title2())
                                .foregroundColor(BetaPalette.textPrimary)
                            Text(BetaStreakEngine.streakEmoji(days: repo.days))
                                .font(.system(size: 36))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .background(BetaPalette.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Goals")
                        .font(BetaFont.headline())
                        .foregroundColor(BetaPalette.textPrimary)
                }
            }
        }
    }

    // MARK: - Components

    private func goalRow(icon: String, color: Color, label: String, current: Double, target: Double, unit: String, progress: Double) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 24)
                Text(label)
                    .font(BetaFont.subheadline())
                    .foregroundColor(BetaPalette.textSecondary)
                Spacer()
                Text("\(String(format: unit == "h" ? "%.1f" : "%.0f", current))\(unit) / \(String(format: unit == "h" ? "%.1f" : "%.0f", target))\(unit)")
                    .font(BetaFont.caption())
                    .foregroundColor(BetaPalette.textPrimary)
            }
            BetaProgressBar(value: progress, color: color)
        }
    }

    private func sliderRow(label: String, value: Binding<Double>, range: ClosedRange<Double>, step: Double, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(BetaFont.subheadline())
                    .foregroundColor(BetaPalette.textSecondary)
                Spacer()
                Text("\(String(format: unit == "h" ? "%.1f" : "%.0f", value.wrappedValue))\(unit)")
                    .font(BetaFont.body())
                    .foregroundColor(BetaPalette.textPrimary)
            }
            Slider(value: value, in: range, step: step)
                .tint(BetaPalette.primary)
        }
    }

    // MARK: - Data

    private var currentSleepHours: Double {
        (repo.days.last?.totalSleepMin ?? 0) / 60.0
    }

    private var currentRecovery: Double {
        repo.days.last?.recovery ?? 0
    }

    private var currentSteps: Int {
        repo.days.last?.steps ?? 0
    }

    private var weeklyStrainSum: Double {
        let last7 = repo.days.suffix(7)
        return last7.compactMap { $0.strain }.reduce(0, +)
    }

    private var weeklyStrainProgress: Double {
        guard weeklyStrainTarget > 0 else { return 0 }
        return weeklyStrainSum / weeklyStrainTarget
    }
}
