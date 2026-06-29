// ByeDPIService.swift
// DPISwitch
//
// Сервисный слой для управления ByeDPI прокси.
// Изолирует ViewModel от прямых вызовов ByeDPI API.
// Отвечает только за запуск/остановку и предоставление текущего статуса.

import Foundation
import SwByeDPI

/// Результат операции запуска прокси
enum ProxyStartResult {
    case success
    case alreadyRunning
    case failure(String)
}

/// Сервис для управления ByeDPI SOCKS-прокси
final class ByeDPIService {

    // MARK: - Singleton

    static let shared = ByeDPIService()
    private init() {}

    // MARK: - Публичное API

    /// Запущен ли прокси прямо сейчас
    var isRunning: Bool {
        ByeDPI.proxyStarted
    }

    /// Адрес прокси-сервера (для отображения пользователю)
    var proxyAddress: String {
        "\(currentConfig?.listenIP ?? "127.0.0.1"):\(currentConfig?.listenPort ?? 10800)"
    }

    // MARK: - Приватное состояние

    /// Текущая конфигурация запущенного прокси (nil если не запущен)
    private(set) var currentConfig: SBDConfig?

    // MARK: - Запуск

    /// Запускает ByeDPI прокси с переданной конфигурацией.
    /// Если прокси уже запущен — сначала останавливает его.
    /// - Parameters:
    ///   - config: Конфигурация запуска (IP, порт, DPI-аргументы)
    ///   - completion: Вызывается на главном потоке с результатом запуска
    func start(with config: SBDConfig, completion: @escaping (ProxyStartResult) -> Void) {
        // Если уже запущен — перезапускаем с новой конфигурацией
        if isRunning {
            _ = ByeDPI.stop()
        }

        currentConfig = config

        ByeDPI.start(args: config.args) { [weak self] error in
            // Этот колбэк вызывается ТОЛЬКО при ошибке запуска
            DispatchQueue.main.async {
                self?.currentConfig = nil
                let message = error.errorDescription
                completion(.failure(message))
            }
        }

        // Небольшая задержка — даём потоку byedpi запуститься
        // и проверяем состояние через proxyStarted
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            if self.isRunning {
                completion(.success)
            }
            // Если не запустился — ошибка придёт через колбэк выше
        }
    }

    // MARK: - Остановка

    /// Останавливает ByeDPI прокси
    /// - Returns: true если остановка прошла успешно
    @discardableResult
    func stop() -> Bool {
        let result = ByeDPI.stop()
        currentConfig = nil
        return result == 0
    }

    /// Принудительная остановка (только закрывает fd, без fake SOCKS hello)
    @discardableResult
    func forceStop() -> Bool {
        let result = ByeDPI.forceStop()
        currentConfig = nil
        return result == 0
    }
}
