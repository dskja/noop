import SwiftUI
import WhoopStore

// MARK: - Beta Settings View
//
// Device info, profile editing, unit preferences, and about section.
// Styled with the beta design system.

struct BetaSettingsView: View {
    @EnvironmentObject var live: LiveState
    @EnvironmentObject var profile: ProfileStore
    @EnvironmentObject var model: AppModel
    @EnvironmentObject var repo: Repository
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    deviceCard
                    profileCard
                    unitsCard
                    aboutCard
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .background(BetaPalette.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(BetaFont.headline())
                        .foregroundColor(BetaPalette.textPrimary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(BetaFont.subheadline())
                        .foregroundColor(BetaPalette.primary)
                }
            }
        }
    }

    // MARK: - Device Card

    private var deviceCard: some View {
        BetaCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .foregroundColor(BetaPalette.primary)
                    Text("Device")
                        .font(BetaFont.headline())
                        .foregroundColor(BetaPalette.textPrimary)
                    Spacer()
                    if live.connected {
                        BetaPill(text: "Connected", color: BetaPalette.tertiary, icon: "checkmark.circle.fill")
                    } else {
                        BetaPill(text: "Offline", color: BetaPalette.textTertiary, icon: "circle.slash")
                    }
                }

                infoRow("Status", live.connected ? "Connected" : "Not connected")
                infoRow("Bond", live.encryptedBond ? "Encrypted" : (live.bonded ? "Paired" : "Not paired"))
                if let name = live.advertisingName {
                    infoRow("Name", name)
                }
                if let fw = live.strapFirmware {
                    infoRow("Firmware", fw)
                }
                if let batt = live.batteryPct {
                    HStack {
                        Text("Battery")
                            .font(BetaFont.subheadline())
                            .foregroundColor(BetaPalette.textSecondary)
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: live.charging == true ? "battery.100.bolt" : batteryIcon(batt))
                                .foregroundColor(batteryColor(batt))
                            Text(String(format: "%.0f%%", batt))
                                .font(BetaFont.subheadline())
                                .foregroundColor(BetaPalette.textPrimary)
                        }
                    }
                }
                if let estimate = live.batteryEstimate {
                    infoRow("Est. Runtime", "~\(Int(estimate.remainingHours))h left")
                }
            }
        }
    }

    // MARK: - Profile Card

    private var profileCard: some View {
        BetaCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(BetaPalette.secondary)
                    Text("Profile")
                        .font(BetaFont.headline())
                        .foregroundColor(BetaPalette.textPrimary)
                    Spacer()
                }

                profileRow("Age", value: "\(profile.age)")
                profileRow("Sex", value: profile.sex.capitalized)
                profileRow("Weight", value: String(format: "%.1f kg", profile.weightKg))
                profileRow("Height", value: String(format: "%.0f cm", profile.heightCm))
                if profile.waistCm > 0 {
                    profileRow("Waist", value: String(format: "%.0f cm", profile.waistCm))
                }
                profileRow("HR Max", value: "\(profile.hrMax) bpm")
            }
        }
    }

    // MARK: - Units Card

    private var unitsCard: some View {
        BetaCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Image(systemName: "ruler")
                        .foregroundColor(BetaPalette.tertiary)
                    Text("Units")
                        .font(BetaFont.headline())
                        .foregroundColor(BetaPalette.textPrimary)
                    Spacer()
                }

                Picker("System", selection: Binding(get: { unitSystem }, set: { unitSystem = $0 })) {
                    Text("Metric").tag(UnitSystem.metric)
                    Text("Imperial").tag(UnitSystem.imperial)
                }
                .pickerStyle(.segmented)
                .foregroundColor(BetaPalette.primary)

                Picker("Temperature", selection: Binding(get: { tempUnit }, set: { tempUnit = $0 })) {
                    Text("°C").tag(TemperatureUnit.celsius)
                    Text("°F").tag(TemperatureUnit.fahrenheit)
                }
                .pickerStyle(.segmented)

                Picker("Effort Scale", selection: Binding(get: { effortScale }, set: { effortScale = $0 })) {
                    Text("0–100").tag(EffortScale.hundred)
                    Text("0–21").tag(EffortScale.whoop)
                }
                .pickerStyle(.segmented)
            }
        }
    }

    // MARK: - About Card

    private var aboutCard: some View {
        BetaCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(BetaPalette.primary)
                    Text("About")
                        .font(BetaFont.headline())
                        .foregroundColor(BetaPalette.textPrimary)
                    Spacer()
                }

                infoRow("App", "NOOP Beta")
                infoRow("Version", Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—")
                infoRow("Build", Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—")
                infoRow("Data Days", "\(repo.days.count)")

                Link(destination: URL(string: "https://github.com/dskja/noop")!) {
                    HStack {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                        Text("View on GitHub")
                            .font(BetaFont.subheadline())
                        Spacer()
                    }
                    .foregroundColor(BetaPalette.primary)
                    .padding(.top, 4)
                }
            }
        }
    }

    // MARK: - Helpers

    private func infoRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(BetaFont.subheadline())
                .foregroundColor(BetaPalette.textSecondary)
            Spacer()
            Text(value)
                .font(BetaFont.subheadline())
                .foregroundColor(BetaPalette.textPrimary)
        }
    }

    private func profileRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(BetaFont.subheadline())
                .foregroundColor(BetaPalette.textSecondary)
            Spacer()
            Text(value)
                .font(BetaFont.subheadline())
                .foregroundColor(BetaPalette.textPrimary)
        }
    }

    private func batteryIcon(_ pct: Double) -> String {
        switch pct {
        case ..<10:    return "battery.0"
        case ..<35:    return "battery.25"
        case ..<65:    return "battery.50"
        case ..<90:    return "battery.75"
        default:       return "battery.100"
        }
    }

    private func batteryColor(_ pct: Double) -> Color {
        switch pct {
        case ..<15:    return BetaPalette.danger
        case ..<30:    return BetaPalette.warning
        default:       return BetaPalette.tertiary
        }
    }

    // MARK: - Unit bindings

    private var unitSystem: UnitSystem {
        get { UnitSystem(rawValue: UserDefaults.standard.string(forKey: UnitPrefs.systemKey) ?? "") ?? .metric }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: UnitPrefs.systemKey) }
    }

    private var tempUnit: TemperatureUnit {
        get {
            let raw = UserDefaults.standard.string(forKey: UnitPrefs.temperatureKey) ?? ""
            return TemperatureUnit(rawValue: raw) ?? unitSystem.temperatureMatching
        }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: UnitPrefs.temperatureKey) }
    }

    private var effortScale: EffortScale {
        get { EffortScale(rawValue: UserDefaults.standard.string(forKey: UnitPrefs.effortScaleKey) ?? "") ?? .hundred }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: UnitPrefs.effortScaleKey) }
    }
}
