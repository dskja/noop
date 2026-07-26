import Foundation
import Combine
import WhoopStore
import StrandAnalytics

// MARK: - Beta AI Coach (Free, No API Keys)
//
// Two-tier coaching engine:
// 1. Rule-based: deterministic, on-device, instant — uses the user's actual metrics
//    (recovery, strain, sleep, HRV, RHR) to generate training prescriptions.
// 2. Pollinations.ai: free text-generation API (no key required) for conversational
//    coaching. Falls back to rule-based when offline or rate-limited.

// MARK: - Chat model (reuses the same ChatMessage struct shape as AICoachEngine)

struct BetaChatMessage: Identifiable, Equatable {
    enum Role: String { case user, assistant }
    let id: UUID
    let role: Role
    let text: String
    init(id: UUID = UUID(), role: Role, text: String) {
        self.id = id
        self.role = role
        self.text = text
    }
}

// MARK: - Engine

@MainActor
final class BetaAICoachEngine: ObservableObject {
    @Published var messages: [BetaChatMessage] = []
    @Published var sending = false
    @Published var errorText: String?
    @Published var dataConsent: Bool {
        didSet { UserDefaults.standard.set(dataConsent, forKey: Self.consentKey) }
    }

    private let repo: Repository
    private let session: URLSession
    private static let consentKey = "beta.ai.dataConsent"

    init(repo: Repository, session: URLSession = .shared) {
        self.repo = repo
        self.session = session
        self.dataConsent = UserDefaults.standard.bool(forKey: Self.consentKey)
    }

    // MARK: - Send

    func send(_ userText: String) async {
        let trimmed = userText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        errorText = nil
        messages.append(BetaChatMessage(role: .user, text: trimmed))
        sending = true
        defer { sending = false }

        let context = dataConsent ? buildContext() : noConsentNote

        // Try Pollinations.ai first (free, no key), fall back to rule-based.
        do {
            let reply = try await pollinationsGenerate(
                systemPrompt: Self.systemPrompt,
                context: context,
                userQuestion: trimmed,
                history: recentHistory()
            )
            let clean = reply.trimmingCharacters(in: .whitespacesAndNewlines)
            messages.append(BetaChatMessage(role: .assistant, text: clean.isEmpty ? ruleBasedReply(question: trimmed, context: context) : clean))
        } catch {
            // Offline or rate-limited — use the on-device rule-based engine.
            let reply = ruleBasedReply(question: trimmed, context: context)
            messages.append(BetaChatMessage(role: .assistant, text: reply))
        }
    }

    // MARK: - Today's Brief (proactive)

    func startBriefIfNeeded() async {
        guard messages.isEmpty, !sending else { return }
        sending = true
        defer { sending = false }

        let context = dataConsent ? buildContext() : noConsentNote
        let brief = ruleBasedBrief(context: context)

        // Try to enrich with Pollinations.ai
        do {
            let reply = try await pollinationsGenerate(
                systemPrompt: Self.systemPrompt,
                context: context,
                userQuestion: "Give me today's coaching brief: my readiness, what training to do, and one recovery tip.",
                history: []
            )
            let clean = reply.trimmingCharacters(in: .whitespacesAndNewlines)
            messages.append(BetaChatMessage(role: .assistant, text: clean.isEmpty ? brief : clean))
        } catch {
            messages.append(BetaChatMessage(role: .assistant, text: brief))
        }
    }

    // MARK: - Rule-based engine (on-device, deterministic, instant)

    private func ruleBasedReply(question: String, context: String) -> String {
        let days = repo.days
        guard let today = days.last else {
            return "I don't have your wearable data yet. Sync your device and I'll give you personalised guidance based on your actual recovery, strain, and sleep."
        }

        let q = question.lowercased()
        let charge = today.recovery ?? 0
        let effort = today.strain ?? 0
        let sleepHours = (today.totalSleepMin ?? 0) / 60.0
        let hrv = today.avgHrv ?? 0
        let rhr = today.restingHr ?? 0

        // Question routing
        if q.contains("sleep") || q.contains("rest") || q.contains("tired") {
            return sleepAdvice(charge: charge, sleepHours: sleepHours, hrv: hrv, rhr: rhr)
        }
        if q.contains("train") || q.contains("workout") || q.contains("exercise") || q.contains("run") || q.contains("lift") {
            return trainingAdvice(charge: charge, effort: effort, sleepHours: sleepHours)
        }
        if q.contains("recover") || q.contains("sore") || q.contains("rest day") {
            return recoveryAdvice(charge: charge, effort: effort)
        }
        if q.contains("stress") || q.contains("anxious") || q.contains("overwhelm") {
            return stressAdvice(hrv: hrv, rhr: rhr)
        }

        // General coaching
        return generalAdvice(charge: charge, effort: effort, sleepHours: sleepHours, hrv: hrv, rhr: rhr)
    }

    private func ruleBasedBrief(context: String) -> String {
        let days = repo.days
        guard let today = days.last else {
            return "Welcome! I'm your free AI coach. Once you sync your wearable, I'll analyse your recovery, strain, and sleep to give you a daily brief and answer your training questions. No API key needed — everything runs on-device or through a free AI service."
        }

        let charge = today.recovery ?? 0
        let effort = today.strain ?? 0
        let sleepHours = (today.totalSleepMin ?? 0) / 60.0
        let hrv = today.avgHrv ?? 0
        let rhr = today.restingHr ?? 0

        var lines: [String] = []

        // 1. Readiness
        let zone = readinessZone(charge: charge)
        lines.append("## Today's Brief")
        lines.append("")
        lines.append("**Readiness:** \(Int(charge.rounded()))/100 — \(zone.label)")
        lines.append("HRV: \(Int(hrv))ms · RHR: \(Int(rhr))bpm · Sleep: \(String(format: "%.1f", sleepHours))h")

        // 2. Training prescription
        lines.append("")
        lines.append("**Training today:**")
        switch zone {
        case .green:
            lines.append("You're cleared to push. A hard session is on the table — go for progressive overload or a higher-intensity block. Your recovery supports it.")
        case .yellow:
            lines.append("Maintain quality over volume. Zone 2, technique work, or a moderate session. Keep effort controlled — don't chase a PR today.")
        case .red:
            lines.append("Active recovery only. Zone 2, mobility, a walk, or extra sleep. Your body is asking for downregulation — listen to it.")
        }

        // 3. Recovery tip
        lines.append("")
        lines.append("**One thing to improve:**")
        if sleepHours < 7 {
            lines.append("Your sleep was \(String(format: "%.1f", sleepHours))h — aim for 7.5–8h tonight. It's the single biggest recovery lever you have.")
        } else if effort > 70 {
            lines.append("Yesterday's strain was high (\(Int(effort.rounded()))). Consider a lighter day to let your body absorb the load.")
        } else if hrv > 0 && hrv < 30 {
            lines.append("Your HRV is on the lower side. Focus on breathwork, hydration, and avoiding late caffeine today.")
        } else {
            lines.append("You're in a good spot. Keep your sleep consistent, hydrate well, and maintain your training rhythm.")
        }

        return lines.joined(separator: "\n")
    }

    private enum ReadinessZone {
        case green, yellow, red
        var label: String {
            switch self {
            case .green:  return "Green light — build & push"
            case .yellow: return "Maintain — quality over volume"
            case .red:    return "Recover — active recovery only"
            }
        }
    }

    private func readinessZone(charge: Double) -> ReadinessZone {
        if charge >= 67 { return .green }
        if charge >= 34 { return .yellow }
        return .red
    }

    private func sleepAdvice(charge: Double, sleepHours: Double, hrv: Double, rhr: Double) -> String {
        var lines: [String] = []
        if sleepHours < 6 {
            lines.append("You only got \(String(format: "%.1f", sleepHours))h — that's below the minimum for recovery. Tonight, aim for 7.5–8h.")
            lines.append("Quick wins: no screens 30min before bed, cool room (18–20°C), and a consistent bedtime.")
        } else if sleepHours < 7 {
            lines.append("\(String(format: "%.1f", sleepHours))h is okay but a bit short. An extra 30–60min would meaningfully improve your recovery.")
        } else {
            lines.append("Nice — \(String(format: "%.1f", sleepHours))h is solid sleep. Keep that consistency going.")
        }
        if hrv > 0 && hrv < 30 {
            lines.append("Your HRV (\(Int(hrv))ms) suggests your nervous system is under stress. Try 5min of slow nasal breathing before bed.")
        }
        return lines.joined(separator: "\n")
    }

    private func trainingAdvice(charge: Double, effort: Double, sleepHours: Double) -> String {
        let zone = readinessZone(charge: charge)
        switch zone {
        case .green:
            return "Your recovery is \(Int(charge.rounded()))/100 — you're cleared to train hard. Go for a progressive overload session or a higher-intensity block. Your body can absorb the load."
        case .yellow:
            return "Recovery is \(Int(charge.rounded()))/100 — maintain today. Zone 2 cardio, technique work, or a moderate session. Keep it controlled; don't chase a PR. Yesterday's effort was \(Int(effort.rounded()))/100."
        case .red:
            return "Recovery is only \(Int(charge.rounded()))/100 — active recovery only. A walk, mobility, or Zone 2 at conversational pace. Your body needs downregulation, not more load."
        }
    }

    private func recoveryAdvice(charge: Double, effort: Double) -> String {
        var lines: [String] = []
        if charge < 34 {
            lines.append("Your recovery is low (\(Int(charge.rounded()))/100). Prioritise:")
            lines.append("- Extra sleep tonight (aim 8h+)")
            lines.append("- Hydration + electrolytes")
            lines.append("- Light movement only (walk, stretch)")
            lines.append("- Protein + anti-inflammatory foods")
        } else if effort > 70 {
            lines.append("Yesterday's strain was high (\(Int(effort.rounded()))/100). Give your body a lighter day to absorb the load — Zone 2 or rest.")
        } else {
            lines.append("You're recovering well (\(Int(charge.rounded()))/100). Keep your sleep consistent and stay hydrated. You're ready for a quality session.")
        }
        return lines.joined(separator: "\n")
    }

    private func stressAdvice(hrv: Double, rhr: Double) -> String {
        var lines: [String] = []
        lines.append("Let's bring your nervous system back into balance.")
        if hrv > 0 {
            lines.append("Your HRV is \(Int(hrv))ms — \(hrv < 30 ? "on the lower side, suggesting sympathetic dominance" : "in a reasonable range").")
        }
        lines.append("")
        lines.append("Try this right now:")
        lines.append("1. **Box breathing:** inhale 4s → hold 4s → exhale 4s → hold 4s. 5 rounds.")
        lines.append("2. **Long exhales:** inhale 4s, exhale 8s. This activates your parasympathetic system.")
        lines.append("3. Step outside or look at something distant for 60 seconds.")
        return lines.joined(separator: "\n")
    }

    private func generalAdvice(charge: Double, effort: Double, sleepHours: Double, hrv: Double, rhr: Double) -> String {
        let zone = readinessZone(charge: charge)
        var lines: [String] = []
        lines.append("Here's your snapshot:")
        lines.append("- **Recovery:** \(Int(charge.rounded()))/100 — \(zone.label)")
        lines.append("- **Yesterday's strain:** \(Int(effort.rounded()))/100")
        lines.append("- **Sleep:** \(String(format: "%.1f", sleepHours))h")
        if hrv > 0 { lines.append("- **HRV:** \(Int(hrv))ms") }
        if rhr > 0 { lines.append("- **RHR:** \(Int(rhr))bpm") }
        lines.append("")
        lines.append("Ask me about training, sleep, recovery, or stress — I'll use your actual numbers.")
        return lines.joined(separator: "\n")
    }

    // MARK: - Context builder

    private func buildContext() -> String {
        let days = repo.days
        guard !days.isEmpty else { return "No wearable data available yet." }

        let recent = Array(days.suffix(7)).reversed()
        var lines: ["USER BIOMETRIC SUMMARY (last 7 days, newest first):"]
        for d in recent {
            let charge = d.recovery.map { Int($0.rounded()) } ?? nil
            let effort = d.strain.map { Int($0.rounded()) } ?? nil
            let sleep = d.totalSleepMin.map { String(format: "%.1f", $0 / 60.0) } ?? "—"
            let hrv = d.avgHrv.map { Int($0) } ?? nil
            let rhr = d.restingHr.map { Int($0) } ?? nil
            lines.append("  Charge: \(charge.map(String.init) ?? "—"), Effort: \(effort.map(String.init) ?? "—"), Sleep: \(sleep)h, HRV: \(hrv.map(String.init) ?? "—")ms, RHR: \(rhr.map(String.init) ?? "—")bpm")
        }
        return lines.joined(separator: "\n")
    }

    private let noConsentNote = "NOTE: The user has not granted access to their biometric data. Coach generally and encourage them to enable data access for personalised advice."

    private func recentHistory() -> [(role: BetaChatMessage.Role, content: String)] {
        let recent = messages.suffix(10)
        return recent.map { ($0.role, $0.text) }
    }

    // MARK: - Pollinations.ai (free, no API key)

    private static let systemPrompt = """
    You are an elite, supportive recovery and performance coach. You may be given a summary of the \
    user's wearable data (charge 0-100 = recovery/readiness, effort 0-100 = cardiovascular load, \
    sleep hours, HRV in ms, resting heart rate in bpm). Coach using autoregulation: charge 67-100 = \
    green light to push, 34-66 = maintain quality, 0-33 = active recovery only. Be specific, punchy, \
    motivating, and cite the user's actual numbers. You are NOT a doctor. Format in simple Markdown.
    """

    private func pollinationsGenerate(
        systemPrompt: String,
        context: String,
        userQuestion: String,
        history: [(role: BetaChatMessage.Role, content: String)]
    ) async throws -> String {
        // Pollinations.ai text generation — free, no API key.
        // Uses OpenAI-compatible chat format via POST to https://text.pollinations.ai/openai
        let url = URL(string: "https://text.pollinations.ai/openai")!
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.timeoutInterval = 30

        // Build messages array
        var messages: [[String: String]] = [["role": "system", "content": systemPrompt]]
        if dataConsent {
            messages.append(["role": "system", "content": context])
        }
        for h in history {
            messages.append(["role": h.role.rawValue, "content": h.content])
        }
        messages.append(["role": "user", "content": userQuestion])

        let body: [String: Any] = [
            "model": "openai",
            "messages": messages,
            "temperature": 0.7
        ]
        req.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await session.data(for: req)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        // Parse OpenAI-compatible response
        guard let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = obj["choices"] as? [[String: Any]],
              let first = choices.first,
              let message = first["message"] as? [String: Any],
              let content = message["content"] as? String else {
            // Fallback: plain text response
            return String(data: data, encoding: .utf8) ?? ""
        }
        return content
    }
}
