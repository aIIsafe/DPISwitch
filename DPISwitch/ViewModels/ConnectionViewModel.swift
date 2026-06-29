// ConnectionViewModel.swift
// DPISwitch
//
// Управляет жизненным циклом подключения.
// iOS 17: @Observable вместо ObservableObject — SwiftUI отслеживает
// только те свойства, которые реально используются во view.

import Foundation
import Observation
import SwByeDPI

@Observable
final class ConnectionViewModel {

    // MARK: - Состояние

    private(set) var connectionState: ConnectionState = .disconnected
    private(set) var proxyAddress: String = "127.0.0.1:10800"
    var errorMessage: String?

    // MARK: - Зависимости

    private let service: ByeDPIService
    private let settingsVM: SettingsViewModel
    private let defaults: UserDefaults

    // MARK: - Инициализация

    init(
        service: ByeDPIService = .shared,
        settingsVM: SettingsViewModel,
        defaults: UserDefaults = .standard
    ) {
        self.service = service
        self.settingsVM = settingsVM
        self.defaults = defaults

        if service.isRunning {
            connectionState = .connected
            proxyAddress = service.proxyAddress
        }
    }

    // MARK: - Публичное API

    func toggleConnection() {
        switch connectionState {
        case .disconnected, .error:
            connect()
        case .connected:
            disconnect()
        case .connecting:
            break
        }
    }

    // MARK: - Приватные методы

    private func connect() {
        connectionState = .connecting

        let config = SBDConfig(
            listenIP: defaults.proxyListenIP,
            listenPort: defaults.proxyListenPort,
            bufSize: defaults.proxyBufSize,
            commandArgs: settingsVM.combinedCmdArgs
        )

        service.start(with: config) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.connectionState = .connected
                self.proxyAddress = self.service.proxyAddress
            case .alreadyRunning:
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
