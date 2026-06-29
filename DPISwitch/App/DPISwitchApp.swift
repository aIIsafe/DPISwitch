// DPISwitchApp.swift
// DPISwitch
//
// Точка входа в приложение.

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
