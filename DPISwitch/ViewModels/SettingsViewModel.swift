// SettingsViewModel.swift
// DPISwitch
//
// iOS 17: @Observable для точечного отслеживания изменений

import Foundation
import Observation

@Observable
final class SettingsViewModel {

    // MARK: - Состояние

    private(set) var presets: [ServicePreset]

    // MARK: - Зависимости

    private let defaults: UserDefaults

    // MARK: - Инициализация

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let savedEnabled = defaults.enabledPresetIDs
        self.presets = PresetLibrary.all.map { preset in
            var mutable = preset
            mutable.isEnabled = savedEnabled.contains(preset.id)
            return mutable
        }
    }

    // MARK: - Публичное API

    func toggle(presetID: String) {
        guard let index = presets.firstIndex(where: { $0.id == presetID }) else { return }
        presets[index].isEnabled.toggle()
        saveEnabledState()
    }

    var combinedCmdArgs: [String] {
        PresetLibrary.buildCombinedArgs(from: presets)
    }

    var hasEnabledPresets: Bool {
        presets.contains { $0.isEnabled }
    }

    // MARK: - Приватные методы

    private func saveEnabledState() {
        let enabledIDs = Set(presets.filter(\.isEnabled).map(\.id))
        defaults.enabledPresetIDs = enabledIDs
    }
}
