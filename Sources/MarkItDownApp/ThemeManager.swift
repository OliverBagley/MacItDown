import SwiftUI
import AppKit

enum AppTheme: String, CaseIterable, Identifiable {

    case system
    case light
    case dark

    var id: String { rawValue }

    var colorScheme: ColorScheme? {

        switch self {

        case .system:
            return nil

        case .light:
            return .light

        case .dark:
            return .dark
        }
    }

    var title: String {

        switch self {

        case .system:
            return "System"

        case .light:
            return "Light"

        case .dark:
            return "Dark"
        }
    }

    var icon: String {

        switch self {

        case .system:
            return "display"

        case .light:
            return "sun.max.fill"

        case .dark:
            return "moon.fill"
        }
    }

    /// Applies this theme to the running NSApplication.
    func applyToApp() {
        let appearance: NSAppearance?
        switch self {
        case .system: appearance = nil
        case .light:  appearance = NSAppearance(named: .aqua)
        case .dark:   appearance = NSAppearance(named: .darkAqua)
        }
        NSApp.appearance = appearance
        NSApp.windows.forEach { $0.appearance = appearance }
    }
}
