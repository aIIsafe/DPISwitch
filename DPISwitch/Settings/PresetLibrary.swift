// PresetLibrary.swift
// DPISwitch
//
// Библиотека встроенных пресетов DPI-обхода.
// Аргументы подобраны на основе стратегий из SwByeDPI Assets/.strategies
// и протестированы с российскими провайдерами.
//
// Архитектура: добавление нового пресета = одна новая запись в `all`.

import Foundation

/// Хранилище встроенных пресетов сервисов
enum PresetLibrary {

    // MARK: - Пресеты

    /// YouTube / Google Video
    /// Стратегия: disorder + split, работает с Google TLS fingerprint
    static let youtube = ServicePreset(
        id: "youtube",
        name: "YouTube",
        systemIconName: "play.rectangle.fill",
        cmdArgs: [
            "-s1", "-d1", "-r1+s",
            "-a1", "-Ar",
            "-o1",
            "-a1", "-At",
            "-r1+s", "-a1"
        ],
        strategyDescription: "Disorder + split для Google TLS"
    )

    /// TikTok
    /// Стратегия: fake + split, подходит для ByteDance CDN
    static let tiktok = ServicePreset(
        id: "tiktok",
        name: "TikTok",
        systemIconName: "music.note",
        cmdArgs: [
            "-s1", "-q1",
            "-a1", "-Ar",
            "-s5", "-o1+s",
            "-a1", "-At",
            "-f-1", "-r1+s", "-a1"
        ],
        strategyDescription: "Fake + split для ByteDance CDN"
    )

    /// Discord
    /// Стратегия: split + disorder по нарастающей, подходит для Cloudflare
    static let discord = ServicePreset(
        id: "discord",
        name: "Discord",
        systemIconName: "bubble.left.and.bubble.right.fill",
        cmdArgs: [
            "-d1", "-s1+s",
            "-s3+s", "-s6+s",
            "-s9+s", "-s12+s",
            "-s15+s", "-s20+s",
            "-s30+s", "-a1"
        ],
        strategyDescription: "Split cascade для Cloudflare"
    )

    // MARK: - Список всех пресетов (добавляй сюда новые)

    static let all: [ServicePreset] = [
        youtube,
        tiktok,
        discord
    ]

    // MARK: - Вспомогательные методы

    /// Возвращает пресет по ID
    static func preset(byID id: String) -> ServicePreset? {
        all.first { $0.id == id }
    }

    /// Генерирует объединённые cmdArgs из набора включённых пресетов.
    /// Если включено несколько — аргументы объединяются через блоки `-a1`.
    /// Если ни один не включён — возвращает базовую стратегию.
    static func buildCombinedArgs(from presets: [ServicePreset]) -> [String] {
        let enabled = presets.filter { $0.isEnabled }

        if enabled.isEmpty {
            // Базовая стратегия — работает для большинства сервисов
            return ["-s1", "-d1", "-r1+s", "-a1"]
        }

        if enabled.count == 1 {
            return enabled[0].cmdArgs
        }

        // Несколько пресетов: объединяем через разделитель `-a1`
        // byedpi читает аргументы как цепочку стратегий
        var combined: [String] = []
        for (index, preset) in enabled.enumerated() {
            combined.append(contentsOf: preset.cmdArgs)
            if index < enabled.count - 1 {
                // Убедимся что блок завершается -a1 перед следующим
                if combined.last != "-a1" {
                    combined.append("-a1")
                }
            }
        }
        return combined
    }
}
