import SwiftUI

@main
struct MacItDown: App {

    @AppStorage("selectedTheme")
    private var selectedTheme = AppTheme.system.rawValue

    var body: some Scene {

        WindowGroup {

            ContentView()
                .preferredColorScheme(AppTheme(rawValue: selectedTheme)?.colorScheme)
                .task {
                    (AppTheme(rawValue: selectedTheme) ?? .system).applyToApp()
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified(showsTitle: false))
        .defaultSize(width: 620, height: 520)
    }
}
