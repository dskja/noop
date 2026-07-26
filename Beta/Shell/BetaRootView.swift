import SwiftUI

// MARK: - Beta Root View — Card-based feed shell
//
// Replaces the tab-based RootTabView with a scrollable card feed.
// Navigation via a bottom bar with 4 sections: Today, Coach, Goals, Insights.

struct BetaRootView: View {
    @AppStorage("beta.onboarded") private var onboarded = false
    @AppStorage("beta.acceptedTerms") private var acceptedTerms = false
    @EnvironmentObject var model: AppModel

    enum Section: Int, CaseIterable {
        case today, coach, goals, insights
        var label: String {
            switch self {
            case .today:    return "Today"
            case .coach:    return "Coach"
            case .goals:    return "Goals"
            case .insights: return "Insights"
            }
        }
        var icon: String {
            switch self {
            case .today:    return "house.fill"
            case .coach:    return "brain.head.profile"
            case .goals:    return "target"
            case .insights: return "chart.xyaxis.line"
            }
        }
    }

    @State private var selectedSection: Section = .today

    var body: some View {
        ZStack {
            BetaPalette.background.ignoresSafeArea()

            if !onboarded {
                BetaOnboarding(onFinished: { onboarded = true })
                    .transition(.opacity)
                    .zIndex(1)
            } else if !acceptedTerms {
                BetaTermsGate(onAccept: { acceptedTerms = true })
                    .transition(.opacity)
                    .zIndex(2)
            } else {
                VStack(spacing: 0) {
                    content
                    bottomBar
                }
            }
        }
        .animation(.easeInOut(duration: 0.35), value: onboarded)
        .animation(.easeInOut(duration: 0.35), value: acceptedTerms)
    }

    @ViewBuilder
    private var content: some View {
        switch selectedSection {
        case .today:    BetaTodayFeed()
        case .coach:    BetaCoachChat()
        case .goals:    BetaGoalsView()
        case .insights: BetaInsightsView()
        }
    }

    private var bottomBar: some View {
        HStack(spacing: 0) {
            ForEach(Section.allCases, id: \.self) { section in
                Button {
                    withAnimation(.spring(duration: 0.3)) {
                        selectedSection = section
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: section.icon)
                            .font(.system(size: 22, weight: .semibold))
                        Text(section.label)
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                    }
                    .foregroundColor(selectedSection == section ? BetaPalette.primary : BetaPalette.textTertiary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
            }
        }
        .padding(.bottom, 2)
        .background(
            BetaPalette.cardBackground.opacity(0.95)
                .overlay(.ultraThinMaterial)
        )
        .overlay(
            Rectangle()
                .fill(Color.white.opacity(0.06))
                .frame(height: 1),
            alignment: .top
        )
    }
}

// MARK: - Terms gate (simplified for beta)

struct BetaTermsGate: View {
    @State private var scrolled = false
    var onAccept: () -> Void

    var body: some View {
        ZStack {
            BetaPalette.background.ignoresSafeArea()
            VStack(spacing: 24) {
                Spacer()
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 56))
                    .foregroundColor(BetaPalette.primary)
                Text("Terms & Privacy")
                    .font(BetaFont.title())
                    .foregroundColor(BetaPalette.textPrimary)
                Text("NOOP Beta works entirely on your device. Your biometric data never leaves your phone unless you explicitly ask the AI coach a question. No account, no cloud sync, no tracking.")
                    .font(BetaFont.body())
                    .foregroundColor(BetaPalette.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                Spacer()
                VStack(spacing: 12) {
                    Button("I Agree") { onAccept() }
                        .buttonStyle(BetaButton(style: .primary))
                    Button("Read Full Terms") {
                        if let url = URL(string: "https://github.com/dskja/noop/blob/main/TERMS.md") {
                            UIApplication.shared.open(url)
                        }
                    }
                    .font(BetaFont.subheadline())
                    .foregroundColor(BetaPalette.textSecondary)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
}
