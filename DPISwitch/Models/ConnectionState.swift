// ConnectionState.swift
// DPISwitch
//
// Состояние подключения к ByeDPI прокси.

import Foundation

/// Текущее состояние соединения
enum ConnectionState: Equatable {

    /// Прокси не запущен
    case disconnected

    /// Прокси запускается (переходное состояние)
    case connecting

    /// Прокси запущен и принимает соединения
    case connected

    /// Произошла ошибка при запуске
    case error(String)

    // MARK: - Вычисляемые свойства

    /// Человекочитаемый статус для отображения
    var displayTitle: String {
        switch self {
        case .disconnected: return "Disconnected"
        case .connecting:   return "Connecting..."
        case .connected:    return "Connected"
        case .error:        return "Error"
        }
    }

    /// Запущен ли прокси в данный момент
    var isActive: Bool {
        if case .connected = self { return true }
        return false
    }

    /// Идёт ли переходный процесс
    var isTransitioning: Bool {
        if case .connecting = self { return true }
        return false
    }

    // MARK: - Equatable

    static func == (lhs: ConnectionState, rhs: ConnectionState) -> Bool {
        switch (lhs, rhs) {
        case (.disconnected, .disconnected): return true
        case (.connecting, .connecting):     return true
        case (.connected, .connected):       return true
        case (.error(let l), .error(let r)): return l == r
        default: return false
        }
    }
}
