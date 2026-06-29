// DPISwitchApp.swift
// DPISwitch
//
// Точка входа. iOS 17+.

import SwiftUI

@main
struct DPISwitchApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(.dark)
        }
    }
}
