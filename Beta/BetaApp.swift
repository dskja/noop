#if os(iOS)
import SwiftUI
import StrandDesign

// MARK: - NOOP Beta — Entry Point
//
// Completely separate iOS app that reuses the shared data layer (AppModel, BLE,
// WhoopStore, StrandAnalytics) but provides its own UI shell, onboarding, design
// system, and a free AI coach (no API keys).

@main
struct BetaApp: App {
    @StateObject private var model: AppModel
    @StateObject private var health: HealthKitBridge
    @StateObject private var watch = WatchSessionBridge()
    @StateObject private var router = NavRouter()
    @StateObject private var betaCoach: BetaAICoachEngine
    @State private var liveActivity = LiveActivityController()
    @Environment(\.scenePhase) private var scenePhase

    init() {
        let model = AppModel()
        _model = StateObject(wrappedValue: model)
        _health = StateObject(wrappedValue: HealthKitBridge(
            repo: model.repo,
            appleDeviceId: model.appleDeviceId,
            noopDeviceId: model.deviceId
        ))
        _betaCoach = StateObject(wrappedValue: BetaAICoachEngine(repo: model.repo))
    }

    var body: some Scene {
        WindowGroup {
            BetaRootView()
                .environmentObject(model)
                .environmentObject(model.live)
                .environmentObject(model.repo)
                .environmentObject(model.profile)
                .environmentObject(model.behavior)
                .environmentObject(model.intelligence)
                .environmentObject(betaCoach)
                .environmentObject(health)
                .environmentObject(router)
                .environmentObject(UpdateStore.shared)
                .environment(\.stressNudgeCenter, model.stressNudgeCenter)
                .preferredColorScheme(.dark)
                .onReceive(model.live.$heartRate) { _ in
                    let day = Repository.widgetAnchor(days: model.repo.days)
                    let bpm = model.live.connected ? (model.bpm ?? model.live.heartRate) : nil
                    liveActivity.update(
                        bpm: bpm,
                        recovery: day?.recovery.map { Int($0.rounded()) },
                        connected: model.live.connected,
                        effort: day?.strain.map { Int($0.rounded()) }
                    )
                }
                .task {
                    watch.activate()
                    await watch.pushLatest(from: model)
                }
                .onChange(of: scenePhase) { _, phase in
                    if phase == .active {
                        model.drainPendingIntents()
                        model.applySmartAlarm()
                        Task {
                            health.refreshAuthIfPreviouslyGranted()
                            await health.sync()
                            await WidgetSnapshot.publish(from: model)
                            await watch.pushLatest(from: model)
                        }
                    }
                }
        }
    }
}
#endif
