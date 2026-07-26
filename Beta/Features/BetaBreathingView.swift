import SwiftUI

// MARK: - Beta Breathing Exercise
//
// A guided box breathing exercise with animated visual guide.
// Box breathing: inhale 4s → hold 4s → exhale 4s → hold 4s.

struct BetaBreathingView: View {
    @State private var phase: BreathPhase = .idle
    @State private var scale: CGFloat = 0.4
    @State private var completedRounds = 0
    @State private var timer: Timer?
    @State private var phaseTimeLeft: Int = 0
    @Environment(\.dismiss) private var dismiss

    private let totalRounds = 5
    private let phaseDuration = 4

    enum BreathPhase: String {
        case idle, inhale, holdIn, exhale, holdOut, done
        var instruction: String {
            switch self {
            case .idle:   return "Tap to begin"
            case .inhale: return "Breathe In"
            case .holdIn: return "Hold"
            case .exhale: return "Breathe Out"
            case .holdOut:return "Hold"
            case .done:   return "Nice work!"
            }
        }
    }

    var body: some View {
        ZStack {
            BetaPalette.background.ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Animated circle
                ZStack {
                    Circle()
                        .fill(BetaPalette.tertiary.opacity(0.1))
                        .frame(width: 240, height: 240)

                    Circle()
                        .fill(BetaPalette.tertiary.opacity(0.2))
                        .frame(width: 180, height: 180)

                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [BetaPalette.tertiary.opacity(0.6), BetaPalette.tertiary.opacity(0.2)],
                                center: .center,
                                startRadius: 10,
                                endRadius: 80
                            )
                        )
                        .scaleEffect(scale)
                        .frame(width: 160, height: 160)
                        .animation(.easeInOut(duration: Double(phaseDuration)), value: scale)

                    VStack(spacing: 8) {
                        Text(phase.instruction)
                            .font(BetaFont.title())
                            .foregroundColor(BetaPalette.textPrimary)
                        if phase != .idle && phase != .done {
                            Text("\(phaseTimeLeft)")
                                .font(BetaFont.metric())
                                .foregroundColor(BetaPalette.tertiary)
                        }
                    }
                }

                // Rounds indicator
                if phase != .idle {
                    HStack(spacing: 8) {
                        ForEach(0..<totalRounds, id: \.self) { i in
                            Circle()
                                .fill(i < completedRounds ? BetaPalette.tertiary : Color.white.opacity(0.15))
                                .frame(width: 10, height: 10)
                        }
                    }
                }

                if phase == .idle {
                    Button("Start Breathing") { start() }
                        .buttonStyle(BetaButton(style: .primary))
                } else if phase == .done {
                    VStack(spacing: 16) {
                        Text("You completed \(completedRounds) rounds of box breathing.")
                            .font(BetaFont.body())
                            .foregroundColor(BetaPalette.textSecondary)
                            .multilineTextAlignment(.center)
                        Button("Done") { dismiss() }
                            .buttonStyle(BetaButton(style: .primary))
                    }
                } else {
                    Button("Stop") { stop() }
                        .buttonStyle(BetaButton(style: .ghost))
                }

                Spacer()

                Text("Box breathing calms your nervous system by activating the parasympathetic branch. 5 rounds = 80 seconds.")
                    .font(BetaFont.caption())
                    .foregroundColor(BetaPalette.textTertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .padding(.horizontal, 32)
        }
    }

    private func start() {
        completedRounds = 0
        nextPhase()
    }

    private func stop() {
        timer?.invalidate()
        timer = nil
        phase = .idle
        scale = 0.4
        completedRounds = 0
    }

    private func nextPhase() {
        if completedRounds >= totalRounds {
            phase = .done
            scale = 0.4
            return
        }

        let phases: [BreathPhase] = [.inhale, .holdIn, .exhale, .holdOut]
        let currentIndex = phases.firstIndex(of: phase) ?? -1
        let nextIndex = (currentIndex + 1) % phases.count

        if nextIndex == 0 && currentIndex != -1 {
            completedRounds += 1
            if completedRounds >= totalRounds {
                phase = .done
                scale = 0.4
                return
            }
        }

        let next = phases[nextIndex]
        phase = next
        phaseTimeLeft = phaseDuration

        switch next {
        case .inhale:  scale = 1.0
        case .holdIn:  scale = 1.0
        case .exhale:  scale = 0.4
        case .holdOut: scale = 0.4
        default: break
        }

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            phaseTimeLeft -= 1
            if phaseTimeLeft <= 0 {
                t.invalidate()
                nextPhase()
            }
        }
    }
}
