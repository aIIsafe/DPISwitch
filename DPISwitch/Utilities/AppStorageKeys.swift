// AppStorageKeys.swift
// DPISwitch
//
// Ключи UserDefaults для хранения настроек приложения.

import Foundation

/// Ключи хранилища настроек
enum AppStorageKeys {

    /// Идентификаторы включённых пресетов (Set<String>, сериализованный в Data)
    static let enabledPresetIDs = "enabledPresetIDs"

    /// IP-адрес SOCKS-прокси byedpi
    static let proxyListenIP = "proxyListenIP"

    /// Порт SOCKS-прокси byedpi
    static let proxyListenPort = "proxyListenPort"

    /// Размер буфера byedpi (байты)
    static let proxyBufSize = "proxyBufSize"
}

// MARK: - UserDefaults расширение для типобезопасного доступа

extension UserDefaults {

    /// Включённые ID пресетов
    var enabledPresetIDs: Set<String> {
        get {
            guard let data = data(forKey: AppStorageKeys.enabledPresetIDs),
                  let decoded = try? JSONDecoder().decode(Set<String>.self, from: data)
            else { return [] }
            return decoded
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            set(data, forKey: AppStorageKeys.enabledPresetIDs)
        }
    }

    /// IP-адрес прокси (по умолчанию 127.0.0.1)
    var proxyListenIP: String {
        get { string(forKey: AppStorageKeys.proxyListenIP) ?? "127.0.0.1" }
        set { set(newValue, forKey: AppStorageKeys.proxyListenIP) }
    }

    /// Порт прокси (по умолчанию 10800)
    var proxyListenPort: UInt16 {
        get {
            let raw = integer(forKey: AppStorageKeys.proxyListenPort)
            return raw > 0 ? UInt16(raw) : 10800
        }
        set { set(Int(newValue), forKey: AppStorageKeys.proxyListenPort) }
    }

    /// Размер буфера (по умолчанию 16384)
    var proxyBufSize: UInt32 {
        get {
            let raw = integer(forKey: AppStorageKeys.proxyBufSize)
            return raw > 0 ? UInt32(raw) : 16384
        }
        set { set(Int(newValue), forKey: AppStorageKeys.proxyBufSize) }
    }
}
