// ConnectionViewModel.swift
// DPISwitch
//
// Главный ViewModel — управляет жизненным циклом подключения.
// Связывает UI (HomeView) с ByeDPIService и SettingsViewModel.

import Foundation
import Combine
import SwByeDPI

@MainActor
final class ConnectionViewModel: ObservableObject {

    // MARK: - Published свойства

    /// Текущее состояние соединения
    @Published private(set) var connectionState: ConnectionState = .disconnected

    /// Адрес прокси для отображения (127.0.0.1:10800)
    @Published private(set) var proxyAddress: String = "127.0.0.1:10800"

    /// Сообщение об ошибке (показывается в алёрте)
    @Published var errorMessage: String?

    // MARK: - Зависимости

    private let service: ByeDPIService
    private let settingsViewModel: SettingsViewModel
    private let defaults: UserDefaults

    // MARK: - Инициализация

    init(
        service: ByeDPIService = .shared,
        settingsViewModel: SettingsViewModel,
        defaults: UserDefaults = .standard
    ) {
        self.service = service
        self.settingsViewModel = settingsViewModel
        self.defaults = defaults

        // Синхронизируем состояние при запуске (мог ли прокси остаться запущенным)
        if service.isRunning {
            connectionState = .connected
            proxyAddress = service.proxyAddress
        }
    }

    // MARK: - Основное действие — переключение

    /// Главное действие кнопки: подключить или отключить
    func toggleConnection() {
        switch connectionState {
        case .disconnected, .error:
            connect()
        case .connected:
            disconnect()
        case .connecting:
            // Игнорируем нажатие во время переходного состояния
            break
        }
    }

    // MARK: - Приватные методы

    private func connect() {
        connectionState = .connecting

        // Собираем конфигурацию из настроек пользователя
        let config = SBDConfig(
            listenIP: defaults.proxyListenIP,
            listenPort: defaults.proxyListenPort,
            bufSize: defaults.proxyBufSize,
            commandArgs: settingsViewModel.combinedCmdArgs
        )

        service.start(with: config) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.connectionState = .connected
                self.proxyAddress = self.service.proxyAddress

            case .alreadyRunning:
                // Прокси уже запущен — считаем connected
                self.connectionState = .connected
                self.proxyAddress = self.service.proxyAddress

            case .failure(let message):
                self.connectionState = .error(message)
                self.errorMessage = message
            }
        }
    }

    private func disconnect() {
        service.stop()
        connectionState = .disconnected
    }
}
