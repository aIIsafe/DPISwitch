// Color+DPISwitch.swift
// DPISwitch
//
// Цветовая палитра приложения.
// Все цвета определены здесь — изменение дизайна в одном месте.

import SwiftUI

extension Color {

    // MARK: - Фоны

    /// Основной фон приложения (#0D0D0D)
    static let appBackground = Color(red: 0.051, green: 0.051, blue: 0.051)

    /// Вторичный фон (карточки, секции)
    static let appSurface = Color(red: 0.11, green: 0.11, blue: 0.118)

    // MARK: - Кнопка подключения

    /// Цвет кнопки в состоянии Disconnected (#3A3A3C)
    static let buttonInactive = Color(red: 0.227, green: 0.227, blue: 0.235)

    /// Цвет кнопки в состоянии Connected (#007AFF — Apple Blue)
    static let buttonActive = Color(red: 0.0, green: 0.478, blue: 1.0)

    /// Цвет кнопки в состоянии Connecting (промежуточный)
    static let buttonConnecting = Color(red: 0.0, green: 0.3, blue: 0.7)

    /// Цвет кнопки в состоянии Error (#FF3B30)
    static let buttonError = Color(red: 1.0, green: 0.231, blue: 0.188)

    // MARK: - Текст

    /// Основной текст
    static let textPrimary = Color.white

    /// Вторичный текст (статус, подписи)
    static let textSecondary = Color(red: 0.557, green: 0.557, blue: 0.576)

    // MARK: - Разделители

    /// Цвет разделителя в списках
    static let appSeparator = Color(red: 0.18, green: 0.18, blue: 0.19)

    // MARK: - Вспомогательный метод

    /// Возвращает цвет кнопки для данного состояния
    static func buttonColor(for state: ConnectionState) -> Color {
        switch state {
        case .disconnected: return .buttonInactive
        case .connecting:   return .buttonConnecting
        case .connected:    return .buttonActive
        case .error:        return .buttonError
        }
    }
}
