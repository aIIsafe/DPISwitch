// SettingsViewModel.swift
// DPISwitch
//
// ViewModel для экрана настроек.
// Управляет состоянием пресетов и сохраняет выбор пользователя.

import Foundation
import Combine

final class SettingsViewModel: ObservableObject {

    // MARK: - Published свойства

    /// Список пресетов с актуальным состоянием isEnabled
    @Published private(set) var presets: [ServicePreset]

    // MARK: - Зависимости

    private let defaults: UserDefaults

    // MARK: - Инициализация

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        // Загружаем сохранённый выбор пользователя
        let savedEnabled = defaults.enabledPresetIDs

        // Применяем сохранённое состояние к встроенным пресетам
        self.presets = PresetLibrary.all.map { preset in
            var mutable = preset
            mutable.isEnabled = savedEnabled.contains(preset.id)
            return mutable
        }
    }

    // MARK: - Публичное API

    /// Переключает состояние пресета
    /// - Parameter presetID: ID пресета из PresetLibrary
    func toggle(presetID: String) {
        guard let index = presets.firstIndex(where: { $0.id == presetID }) else { return }
        presets[index].isEnabled.toggle()
        saveEnabledState()
    }

    /// Возвращает объединённые аргументы byedpi на основе включённых пресетов
    var combinedCmdArgs: [String] {
        PresetLibrary.buildCombinedArgs(from: presets)
    }

    /// Есть ли хотя бы один включённый пресет
    var hasEnabledPresets: Bool {
        presets.contains { $0.isEnabled }
    }

    // MARK: - Приватные методы

    private func saveEnabledState() {
        let enabledIDs = Set(presets.filter(\.isEnabled).map(\.id))
        defaults.enabledPresetIDs = enabledIDs
    }
}
