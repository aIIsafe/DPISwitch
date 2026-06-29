// Color+DPISwitch.swift
// DPISwitch
//
// Цветовая система приложения.
// Все цвета — в одном месте.

import SwiftUI

extension Color {

    // MARK: - Фон

    static let appBackground = Color(red: 0.02, green: 0.02, blue: 0.07)
    static let appSurface    = Color(red: 0.08, green: 0.08, blue: 0.13)

    // MARK: - Состояния кнопки

    /// Disconnected — приглушённый серо-синий
    static let buttonInactive  = Color(red: 0.22, green: 0.23, blue: 0.30)

    /// Connected — Apple Blue / Electric Blue
    static let buttonActive    = Color(red: 0.0,  green: 0.48, blue: 1.0)

    /// Connecting — переходный
    static let buttonConnecting = Color(red: 0.0, green: 0.30, blue: 0.75)

    /// Error — Apple Red
    static let buttonError     = Color(red: 1.0,  green: 0.23, blue: 0.19)

    // MARK: - Текст

    static let textPrimary   = Color.white
    static let textSecondary = Color(red: 0.60, green: 0.62, blue: 0.70)
    static let textTertiary  = Color(red: 0.40, green: 0.42, blue: 0.50)

    // MARK: - Separator

    static let appSeparator = Color(red: 0.18, green: 0.19, blue: 0.25)

    // MARK: - Preset иконки

    static let youtubeRed  = Color(red: 1.0,  green: 0.18, blue: 0.18)
    static let tiktokCyan  = Color(red: 0.0,  green: 0.85, blue: 0.80)
    static let discordBlue = Color(red: 0.35, green: 0.40, blue: 0.95)

    // MARK: - Вспомогательный метод

    /// Цвет кнопки для данного состояния соединения
    static func buttonColor(for state: ConnectionState) -> Color {
        switch state {
        case .disconnected: return .buttonInactive
        case .connecting:   return .buttonConnecting
        case .connected:    return .buttonActive
        case .error:        return .buttonError
        }
    }

    /// Accent цвет пресета по его ID
    static func presetAccent(for presetID: String) -> Color {
        switch presetID {
        case "youtube":  return .youtubeRed
        case "tiktok":   return .tiktokCyan
        case "discord":  return .discordBlue
        default:         return .buttonActive
        }
    }
}
