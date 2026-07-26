import SwiftUI
#if os(iOS)
import UserNotifications
#endif

// MARK: - Beta Onboarding
//
// A completely new onboarding experience — card-based, animated, visually distinct
// from the existing OnboardingWizard. Uses the Beta design system.

struct BetaOnboarding: View {
    @EnvironmentObject var model: AppModel
    @EnvironmentObject var live: LiveState
    @EnvironmentObject var profile: ProfileStore
    @EnvironmentObject var behavior: BehaviorStore
    var onFinished: () -> Void

    @State private var step = 0
    @State private var ageText = ""
    @State private var selectedSex: ProfileStore.Sex = .male
    @State private var unitSystem: ProfileStore.UnitSystem = .metric
    @State private var animateContent = false

    private let totalSteps = 6

    var body: some View {
        ZStack {
            BetaPalette.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress dots
                HStack(spacing: 8) {
                    ForEach(0..<totalSteps, id: \.self) { i in
                        Capsule()
                            .fill(i <= step ? BetaPalette.primary : Color.white.opacity(0.15))
                            .frame(width: i == step ? 24 : 8, height: 8)
                            .animation(.spring(duration: 0.4), value: step)
                    }
                    Spacer()
                    if step > 0 {
                        Button("Back") { back() }
                            .font(BetaFont.subheadline())
                            .foregroundColor(BetaPalette.textSecondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 8)

                // Content
                TabView(selection: $step) {
                    welcomeStep.tag(0)
                    whatItDoesStep.tag(1)
                    connectStep.tag(2)
                    profileStep.tag(3)
                    notificationsStep.tag(4)
                    readyStep.tag(5)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: step)

                // CTA
                VStack(spacing: 12) {
                    Button(action: advance) {
                        Text(step == totalSteps - 1 ? "Enter NOOP Beta" : ctaLabel)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(BetaButton(style: .primary))

                    if step == totalSteps - 1 {
                        Button("Skip for now") { finish() }
                            .font(BetaFont.subheadline())
                            .foregroundColor(BetaPalette.textSecondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                .padding(.top, 8)
            }
        }
    }

    // MARK: - Steps

    private var ctaLabel: String {
        switch step {
        case 0:  return "Get Started"
        case 1:  return "Continue"
        case 2:  return live.connected ? "Connected!" : "Connect Strap"
        case 3:  return "Save Profile"
        case 4:  return "Continue"
        case 5:  return "Enter NOOP Beta"
        default: return "Continue"
        }
    }

    private var welcomeStep: some View {
        VStack(spacing: 32) {
            Spacer()
            Image(systemName: "heart.text.square.fill")
                .font(.system(size: 80))
                .foregroundStyle(BetaPalette.heroGradient)
                .symbolEffect(.pulse)

            VStack(spacing: 12) {
                Text("NOOP Beta")
                    .font(BetaFont.largeTitle())
                    .foregroundColor(BetaPalette.textPrimary)
                Text("Your body, decoded.\nRecovery · Strain · Sleep — on your wrist, on your phone, for free.")
                    .font(BetaFont.body())
                    .foregroundColor(BetaPalette.textSecondary)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .padding(.horizontal, 32)
    }

    private var whatItDoesStep: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("What you get")
                .font(BetaFont.title())
                .foregroundColor(BetaPalette.textPrimary)

            VStack(spacing: 16) {
                featureRow(icon: "battery.100", title: "Recovery Score", desc: "A daily 0–100 readiness score from HRV, RHR & sleep")
                featureRow(icon: "figure.run", title: "Strain Tracking", desc: "Cardiovascular load from your heart rate, all on-device")
                featureRow(icon: "bed.double.fill", title: "Sleep Staging", desc: "Light, deep & REM detection from your strap's sensors")
                featureRow(icon: "brain.head.profile", title: "Free AI Coach", desc: "Personalised guidance — no API key, no subscription")
                featureRow(icon: "flame.fill", title: "Streaks & Goals", desc: "Build healthy habits with streaks and achievements")
            }
            Spacer()
        }
        .padding(.horizontal, 32)
    }

    private func featureRow(icon: String, title: String, desc: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(BetaPalette.primary)
                .frame(width: 44)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(BetaFont.headline())
                    .foregroundColor(BetaPalette.textPrimary)
                Text(desc)
                    .font(BetaFont.caption())
                    .foregroundColor(BetaPalette.textSecondary)
            }
            Spacer()
        }
    }

    private var connectStep: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: live.connected ? "checkmark.circle.fill" : "antenna.radiowaves.left.and.right")
                .font(.system(size: 64))
                .foregroundColor(live.connected ? BetaPalette.tertiary : BetaPalette.primary)
                .symbolEffect(live.connected ? .bounce : .pulse)

            VStack(spacing: 8) {
                Text(live.connected ? "Strap Connected!" : "Connect Your Strap")
                    .font(BetaFont.title())
                    .foregroundColor(BetaPalette.textPrimary)
                Text(live.connected ? "Your WHOOP is paired and ready." : "NOOP talks directly to your WHOOP strap over Bluetooth. No cloud, no account, no subscription.")
                    .font(BetaFont.body())
                    .foregroundColor(BetaPalette.textSecondary)
                    .multilineTextAlignment(.center)
            }

            if !live.connected {
                BetaCard {
                    VStack(spacing: 12) {
                        if model.live.isScanning {
                            ProgressView()
                                .tint(BetaPalette.primary)
                            Text("Scanning for your strap...")
                                .font(BetaFont.subheadline())
                                .foregroundColor(BetaPalette.textSecondary)
                        } else {
                            Text("Make sure your WHOOP strap is charged and nearby.")
                                .font(BetaFont.caption())
                                .foregroundColor(BetaPalette.textSecondary)
                            Button("Start Scanning") {
                                model.scan()
                            }
                            .buttonStyle(BetaButton(style: .secondary))
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 32)
    }

    private var profileStep: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("About You")
                .font(BetaFont.title())
                .foregroundColor(BetaPalette.textPrimary)
            Text("Used for heart-rate zones, calorie estimates & baselines. Stays on your device.")
                .font(BetaFont.caption())
                .foregroundColor(BetaPalette.textSecondary)
                .multilineTextAlignment(.center)

            BetaCard {
                VStack(spacing: 20) {
                    // Age
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Age")
                            .font(BetaFont.subheadline())
                            .foregroundColor(BetaPalette.textSecondary)
                        TextField("25", text: $ageText)
                            .keyboardType(.numberPad)
                            .font(BetaFont.body())
                            .padding(12)
                            .background(Color.white.opacity(0.06))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .foregroundColor(BetaPalette.textPrimary)
                    }

                    // Sex
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sex")
                            .font(BetaFont.subheadline())
                            .foregroundColor(BetaPalette.textSecondary)
                        HStack(spacing: 12) {
                            sexButton(.male, "Male")
                            sexButton(.female, "Female")
                        }
                    }

                    // Units
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Units")
                            .font(BetaFont.subheadline())
                            .foregroundColor(BetaPalette.textSecondary)
                        HStack(spacing: 12) {
                            unitButton(.metric, "Metric")
                            unitButton(.imperial, "Imperial")
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 32)
    }

    private func sexButton(_ sex: ProfileStore.Sex, _ label: String) -> some View {
        Button(label) {
            selectedSex = sex
            profile.sex = sex
        }
        .font(BetaFont.subheadline())
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(selectedSex == sex ? BetaPalette.primary.opacity(0.2) : Color.white.opacity(0.06))
        .foregroundColor(selectedSex == sex ? BetaPalette.primary : BetaPalette.textSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func unitButton(_ system: ProfileStore.UnitSystem, _ label: String) -> some View {
        Button(label) {
            unitSystem = system
            profile.units = system
        }
        .font(BetaFont.subheadline())
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(unitSystem == system ? BetaPalette.primary.opacity(0.2) : Color.white.opacity(0.06))
        .foregroundColor(unitSystem == system ? BetaPalette.primary : BetaPalette.textSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var notificationsStep: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 64))
                .foregroundColor(BetaPalette.primary)
                .symbolEffect(.pulse)

            VStack(spacing: 8) {
                Text("Stay in the Loop")
                    .font(BetaFont.title())
                    .foregroundColor(BetaPalette.textPrimary)
                Text("Get notified when your recovery drops, when your strap battery is low, or when your AI coach has a tip.")
                    .font(BetaFont.body())
                    .foregroundColor(BetaPalette.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Button("Enable Notifications") {
                requestNotifications()
            }
            .buttonStyle(BetaButton(style: .secondary))

            Spacer()
        }
        .padding(.horizontal, 32)
    }

    private var readyStep: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "rocket.fill")
                .font(.system(size: 80))
                .foregroundStyle(BetaPalette.heroGradient)
                .symbolEffect(.bounce)

            VStack(spacing: 12) {
                Text("You're all set!")
                    .font(BetaFont.largeTitle())
                    .foregroundColor(BetaPalette.textPrimary)
                Text("NOOP Beta is ready to decode your body. Your data stays on your device — no cloud, no account, no subscription.")
                    .font(BetaFont.body())
                    .foregroundColor(BetaPalette.textSecondary)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 8) {
                BetaPill(text: "Free AI Coach", color: BetaPalette.tertiary, icon: "brain.head.profile")
                BetaPill(text: "No API Keys", color: BetaPalette.primary, icon: "key.slash")
                BetaPill(text: "On-Device Data", color: BetaPalette.secondary, icon: "lock.fill")
            }
            Spacer()
        }
        .padding(.horizontal, 32)
    }

    // MARK: - Actions

    private func advance() {
        if step == 3 {
            // Save profile
            if let age = Int(ageText), age > 0 { profile.age = age }
            profile.sex = selectedSex
            profile.units = unitSystem
        }
        if step == totalSteps - 1 {
            finish()
        } else {
            withAnimation { step += 1 }
        }
    }

    private func back() {
        guard step > 0 else { return }
        withAnimation { step -= 1 }
    }

    private func finish() {
        UserDefaults.standard.set(true, forKey: "beta.onboarded")
        onFinished()
    }

    private func requestNotifications() {
        #if os(iOS)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
        #endif
    }
}
