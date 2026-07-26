import SwiftUI

// MARK: - Beta Design System
// A completely new visual language for the beta build — card-based, vibrant,
// with a distinct identity from the main app's StrandPalette/StrandFont.

enum BetaPalette {
    // Primary surfaces
    static let background = Color(red: 0.04, green: 0.04, blue: 0.06)
    static let cardBackground = Color(red: 0.10, green: 0.10, blue: 0.14)
    static let cardBackgroundElevated = Color(red: 0.13, green: 0.13, blue: 0.18)

    // Accents
    static let primary = Color(red: 0.35, green: 0.76, blue: 0.98)      // electric blue
    static let secondary = Color(red: 0.55, green: 0.43, blue: 0.85)    // purple
    static let tertiary = Color(red: 0.20, green: 0.85, blue: 0.60)     // mint green
    static let warning = Color(red: 0.95, green: 0.61, blue: 0.14)      // amber
    static let danger = Color(red: 0.92, green: 0.34, blue: 0.34)       // coral red

    // Recovery / strain colours
    static let recovery = Color(red: 0.20, green: 0.85, blue: 0.60)
    static let strain = Color(red: 0.95, green: 0.42, blue: 0.42)
    static let sleep = Color(red: 0.45, green: 0.55, blue: 0.92)

    // Text
    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.65)
    static let textTertiary = Color(white: 0.40)

    // Gradients
    static let heroGradient = LinearGradient(
        colors: [primary, secondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let recoveryGradient = LinearGradient(
        colors: [recovery, tertiary],
        startPoint: .leading,
        endPoint: .trailing
    )
    static let strainGradient = LinearGradient(
        colors: [strain, warning],
        startPoint: .leading,
        endPoint: .trailing
    )
}

enum BetaFont {
    static func largeTitle() -> Font { .system(size: 34, weight: .bold, design: .rounded) }
    static func title() -> Font { .system(size: 24, weight: .bold, design: .rounded) }
    static func title2() -> Font { .system(size: 20, weight: .semibold, design: .rounded) }
    static func headline() -> Font { .system(size: 17, weight: .semibold, design: .rounded) }
    static func body() -> Font { .system(size: 16, weight: .regular, design: .rounded) }
    static func subheadline() -> Font { .system(size: 14, weight: .medium, design: .rounded) }
    static func caption() -> Font { .system(size: 12, weight: .regular, design: .rounded) }
    static func metric() -> Font { .system(size: 44, weight: .bold, design: .rounded) }
    static func metricSmall() -> Font { .system(size: 28, weight: .bold, design: .rounded) }
}

// MARK: - Beta Card

struct BetaCard<Content: View>: View {
    var gradient: LinearGradient? = nil
    var padding: CGFloat = 20
    @State private var isPressed = false
    let content: Content

    init(gradient: LinearGradient? = nil, padding: CGFloat = 20, @ViewBuilder content: () -> Content) {
        self.gradient = gradient
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(gradient ?? LinearGradient(
                        colors: [BetaPalette.cardBackground, BetaPalette.cardBackgroundElevated],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.3), radius: 12, x: 0, y: 6)
    }
}

// MARK: - Beta Metric Ring

struct BetaMetricRing: View {
    let value: Double          // 0...1
    let color: Color
    let label: String
    let displayValue: String
    var size: CGFloat = 120

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.08), lineWidth: 10)
            Circle()
                .trim(from: 0, to: max(0.001, min(1, value)))
                .stroke(
                    AngularGradient(
                        colors: [color, color.opacity(0.7)],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(duration: 0.8), value: value)

            VStack(spacing: 2) {
                Text(displayValue)
                    .font(BetaFont.metricSmall())
                    .foregroundColor(BetaPalette.textPrimary)
                Text(label)
                    .font(BetaFont.caption())
                    .foregroundColor(BetaPalette.textSecondary)
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Beta Pill

struct BetaPill: View {
    let text: String
    let color: Color
    var icon: String? = nil

    var body: some View {
        HStack(spacing: 4) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .bold))
            }
            Text(text)
                .font(BetaFont.caption())
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(color.opacity(0.2))
        .foregroundColor(color)
        .clipShape(Capsule())
    }
}

// MARK: - Beta Progress Bar

struct BetaProgressBar: View {
    let value: Double  // 0...1
    let color: Color
    var height: CGFloat = 8

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(Color.white.opacity(0.08))
                    .frame(height: height)
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(color)
                    .frame(width: geo.size.width * max(0, min(1, value)), height: height)
                    .animation(.spring(duration: 0.6), value: value)
            }
        }
        .frame(height: height)
    }
}

// MARK: - Beta Button

struct BetaButton: ButtonStyle {
    var style: Style = .primary

    enum Style {
        case primary, secondary, ghost, danger
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BetaFont.headline())
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }

    private var backgroundColor: Color {
        switch style {
        case .primary:   return BetaPalette.primary
        case .secondary: return BetaPalette.secondary
        case .ghost:     return Color.white.opacity(0.08)
        case .danger:    return BetaPalette.danger
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary:   return .black
        case .secondary: return .white
        case .ghost:     return BetaPalette.textPrimary
        case .danger:    return .white
        }
    }
}
