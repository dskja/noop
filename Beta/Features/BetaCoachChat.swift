import SwiftUI
import MarkdownUI

// MARK: - Beta Coach Chat
//
// Chat interface for the free AI coach. Uses BetaAICoachEngine which combines
// rule-based on-device coaching with Pollinations.ai (free, no API key).

struct BetaCoachChat: View {
    @EnvironmentObject var betaCoach: BetaAICoachEngine
    @EnvironmentObject var repo: Repository
    @State private var input = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if betaCoach.messages.isEmpty {
                    emptyState
                } else {
                    messagesList
                }
                composer
            }
            .background(BetaPalette.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 6) {
                        Image(systemName: "brain.head.profile")
                            .foregroundColor(BetaPalette.secondary)
                        Text("Coach")
                            .font(BetaFont.headline())
                            .foregroundColor(BetaPalette.textPrimary)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        betaCoach.dataConsent.toggle()
                    } label: {
                        Image(systemName: betaCoach.dataConsent ? "checkmark.shield.fill" : "shield")
                            .foregroundColor(betaCoach.dataConsent ? BetaPalette.tertiary : BetaPalette.textTertiary)
                    }
                }
            }
            .task {
                await betaCoach.startBriefIfNeeded()
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "brain.head.profile")
                .font(.system(size: 64))
                .foregroundStyle(BetaPalette.heroGradient)
            VStack(spacing: 8) {
                Text("Your Free AI Coach")
                    .font(BetaFont.title())
                    .foregroundColor(BetaPalette.textPrimary)
                Text("Ask about training, recovery, sleep, or stress. I use your actual numbers — no API key needed.")
                    .font(BetaFont.body())
                    .foregroundColor(BetaPalette.textSecondary)
                    .multilineTextAlignment(.center)
            }
            VStack(spacing: 10) {
                suggestionButton("What should I train today?")
                suggestionButton("How's my recovery?")
                suggestionButton("Help me sleep better")
                suggestionButton("I'm feeling stressed")
            }
            Spacer()
        }
        .padding(.horizontal, 32)
    }

    private func suggestionButton(_ text: String) -> some View {
        Button(text) {
            input = text
            sendMessage()
        }
        .buttonStyle(BetaButton(style: .ghost))
    }

    private var messagesList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(betaCoach.messages) { msg in
                        messageBubble(msg)
                            .id(msg.id)
                    }
                    if betaCoach.sending {
                        typingIndicator
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .onChange(of: betaCoach.messages.count) { _, _ in
                withAnimation {
                    proxy.scrollTo(betaCoach.messages.last?.id, anchor: .bottom)
                }
            }
            .onChange(of: betaCoach.sending) { _, _ in
                if betaCoach.sending {
                    withAnimation {
                        proxy.scrollTo(betaCoach.messages.last?.id, anchor: .bottom)
                    }
                }
            }
        }
    }

    private func messageBubble(_ msg: BetaChatMessage) -> some View {
        HStack {
            if msg.role == .user { Spacer() }
            VStack(alignment: msg.role == .user ? .trailing : .leading, spacing: 0) {
                if msg.role == .assistant {
                    Markdown(msg.text)
                        .markdownTheme(.basic)
                        .padding(16)
                        .background(BetaPalette.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .foregroundColor(BetaPalette.textPrimary)
                } else {
                    Text(msg.text)
                        .font(BetaFont.body())
                        .padding(16)
                        .background(BetaPalette.primary)
                        .foregroundColor(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
            }
            if msg.role == .assistant { Spacer() }
        }
    }

    private var typingIndicator: some View {
        HStack {
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(BetaPalette.textTertiary)
                        .frame(width: 8, height: 8)
                        .offset(y: i == 1 ? -3 : 0)
                        .animation(
                            .easeInOut(duration: 0.5)
                                .repeatForever()
                                .delay(Double(i) * 0.15),
                            value: betaCoach.sending
                        )
                }
            }
            .padding(16)
            .background(BetaPalette.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            Spacer()
        }
    }

    private var composer: some View {
        HStack(spacing: 12) {
            TextField("Ask your coach...", text: $input, axis: .vertical)
                .font(BetaFont.body())
                .padding(12)
                .background(Color.white.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .foregroundColor(BetaPalette.textPrimary)
                .focused($isFocused)
                .lineLimit(1...4)

            Button {
                sendMessage()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(input.trimmingCharacters(in: .whitespaces).isEmpty ? BetaPalette.textTertiary : BetaPalette.primary)
            }
            .disabled(input.trimmingCharacters(in: .whitespaces).isEmpty || betaCoach.sending)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(BetaPalette.cardBackground.opacity(0.95))
        .overlay(
            Rectangle()
                .fill(Color.white.opacity(0.06))
                .frame(height: 1),
            alignment: .top
        )
    }

    private func sendMessage() {
        let text = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !betaCoach.sending else { return }
        input = ""
        Task { await betaCoach.send(text) }
    }
}
