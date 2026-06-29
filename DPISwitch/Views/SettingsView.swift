// SettingsView.swift
// DPISwitch
//
// Экран настроек — переключатели для сервисов.
// Каждый тоггл включает/выключает пресет DPI-обхода.
//
// Совместимость: iOS 15+ (Xcode 13 / Big Sur)

import SwiftUI

struct SettingsView: View {

    // MARK: - Зависимости

    @ObservedObject var viewModel: SettingsViewModel

    // MARK: - Окружение

    @Environment(\.dismiss) private var dismiss

    // MARK: - Тело

    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 0) {
                        // Заголовок секции
                        sectionHeader("Services")
                            .padding(.top, 24)

                        // Список пресетов
                        presetsSection

                        // Информационный блок
                        infoBlock
                            .padding(.top, 32)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.buttonActive)
                        .fontWeight(.semibold)
                }
            }
        }
        .navigationViewStyle(.stack)
        .preferredColorScheme(.dark)
    }

    // MARK: - Компоненты

    /// Заголовок секции
    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.textSecondary)
                .textCase(.uppercase)
                .tracking(0.5)
            Spacer()
        }
        .padding(.bottom, 8)
    }

    /// Секция с пресетами
    private var presetsSection: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.presets.enumerated()), id: \.element.id) { index, preset in
                PresetToggleRow(
                    preset: preset,
                    isLast: index == viewModel.presets.count - 1,
                    onToggle: { viewModel.toggle(presetID: preset.id) }
                )
            }
        }
        .background(Color.appSurface)
        .cornerRadius(14)
    }

    /// Информационный блок
    private var infoBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("How it works", systemImage: "info.circle")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.textSecondary)

            Text("DPI Switch runs a local SOCKS5 proxy on your device. Enable the services you want to unblock, then tap Connect on the main screen.")
                .font(.caption)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)

            Text("Proxy address: 127.0.0.1:10800")
                .font(.caption)
                .fontDesign(.monospaced)
                .foregroundColor(.textSecondary)
                .padding(.top, 2)
        }
        .padding(14)
        .background(Color.appSurface)
        .cornerRadius(14)
    }
}

// MARK: - PresetToggleRow

/// Строка пресета с переключателем
private struct PresetToggleRow: View {

    let preset: ServicePreset
    let isLast: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                // Иконка сервиса
                Image(systemName: preset.systemIconName)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(preset.isEnabled ? .buttonActive : .textSecondary)
                    .frame(width: 28, height: 28)
                    .animation(.easeInOut(duration: 0.2), value: preset.isEnabled)

                // Название
                Text(preset.name)
                    .font(.body)
                    .foregroundColor(.textPrimary)

                Spacer()

                // Тоггл
                Toggle("", isOn: Binding(
                    get: { preset.isEnabled },
                    set: { _ in
                        // Тактильная обратная связь
                        let feedback = UIImpactFeedbackGenerator(style: .light)
                        feedback.impactOccurred()
                        onToggle()
                    }
                ))
                .tint(.buttonActive)
                .labelsHidden()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            // Разделитель (кроме последнего элемента)
            if !isLast {
                Divider()
                    .background(Color.appSeparator)
                    .padding(.leading, 58)
            }
        }
    }
}

// MARK: - Preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
            .preferredColorScheme(.dark)
    }
}
