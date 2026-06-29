// ServicePreset.swift
// DPISwitch
//
// Модель пресета DPI-обхода для конкретного сервиса.
// Каждый пресет содержит набор CLI-аргументов byedpi,
// подобранных под особенности трафика сервиса.

import Foundation

/// Пресет DPI-обхода для конкретного сервиса
struct ServicePreset: Identifiable, Codable, Equatable {

    /// Уникальный идентификатор пресета
    let id: String

    /// Отображаемое название сервиса
    let name: String

    /// Иконка SF Symbols
    let systemIconName: String

    /// Аргументы byedpi для этого пресета
    let cmdArgs: [String]

    /// Описание стратегии (для отладки)
    let strategyDescription: String

    /// Включён ли пресет пользователем
    var isEnabled: Bool

    // MARK: - Вспомогательные инициализаторы

    init(
        id: String,
        name: String,
        systemIconName: String,
        cmdArgs: [String],
        strategyDescription: String = "",
        isEnabled: Bool = false
    ) {
        self.id = id
        self.name = name
        self.systemIconName = systemIconName
        self.cmdArgs = cmdArgs
        self.strategyDescription = strategyDescription
        self.isEnabled = isEnabled
    }
}
