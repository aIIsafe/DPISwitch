// SettingsView.swift
// DPISwitch
//
// Экран настроек. Liquid Glass карточки, цветные иконки сервисов.
// iOS 17+ / @Observable

import SwiftUI

struct SettingsView: View {

    // MARK: - ViewModel

    @Bindable var viewModel: SettingsViewModel

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss

    // MARK: - Body

    var body: some View {
        ZStack {
            AnimatedBackground()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {

                    // Заголовок с кнопкой Done
                    headerBar
                        .padding(.top, 20)

                    // Секция сервисов
                    servicesSection

                    // Информационный блок
                    infoSection

                    // О приложении
                    aboutSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
    }

    // MARK: - Компоненты

    /// Верхняя панель с заголовком
    private var headerBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Settings")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text("Configure your bypass")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color.textTertiary)
            }

            Spacer()

            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.textSecondary)
                    .frame(width: 30, height: 30)
                    .liquidGlass(cornerRadius: 15, tintColor: .white, tintOpacity: 0.04)
            }
            .buttonStyle(.plain)
        }
    }

    /// Секция пресетов сервисов
    private var servicesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Services", icon: "app.badge.checkmark")

            VStack(spacing: 1) {
                ForEach(Array(viewModel.presets.enumerated()), id: \.element.id) { index, preset in
                    PresetRow(
                        preset: preset,
                        isFirst: index == 0,
                        isLast: index == viewModel.presets.count - 1,
                        onToggle: {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            viewModel.toggle(presetID: preset.id)
                        }
                    )
                }
            }
            .liquidGlass(cornerRadius: 20, tintColor: .white, tintOpacity: 0.03)
        }
    }

    /// Информация о прокси
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("How to use", icon: "info.circle")

            VStack(alignment: .leading, spacing: 16) {
                infoRow(
                    icon: "1.circle.fill",
                    title: "Enable services",
                    description: "Toggle the services you want to unblock above"
                )
                Divider().background(Color.appSeparator)
                infoRow(
                    icon: "2.circle.fill",
                    title: "Connect",
                    description: "Tap the power button on the main screen"
                )
                Divider().background(Color.appSeparator)
                infoRow(
                    icon: "3.circle.fill",
                    title: "Set proxy",
                    description: "Go to Settings → Wi-Fi → your network → Configure Proxy → Manual\nServer: 127.0.0.1  Port: 10800"
                )
            }
            .padding(16)
            .liquidGlass(cornerRadius: 20, tintColor: .white, tintOpacity: 0.02)
        }
    }

    /// О приложении
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("About", icon: "shield.lefthalf.filled")

            VStack(spacing: 1) {
                aboutRow(title: "Version", value: "1.0.0")
                Divider().background(Color.appSeparator).padding(.leading, 16)
                aboutRow(title: "Engine", value: "byedpi 0.17.3")
                Divider().background(Color.appSeparator).padding(.leading, 16)
                aboutRow(title: "Protocol", value: "SOCKS5")
            }
            .liquidGlass(cornerRadius: 20, tintColor: .white, tintOpacity: 0.02)
        }
    }

    // MARK: - Мелкие компоненты

    private func sectionLabel(_ title: String, icon: String) -> some View {
        Label(title, systemImage: icon)
            .font(.system(size: 13, weight: .semibold, design: .rounded))
            .foregroundStyle(Color.textTertiary)
            .textCase(.uppercase)
            .tracking(0.5)
            .padding(.leading, 4)
    }

    private func infoRow(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(Color.buttonActive)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                Text(description)
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func aboutRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 15))
                .foregroundStyle(Color.textSecondary)
            Spacer()
            Text(value)
                .font(.system(size: 15, weight: .medium, design: .monospaced))
                .foregroundStyle(Color.textTertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - PresetRow

private struct PresetRow: View {

    let preset: ServicePreset
    let isFirst: Bool
    let isLast: Bool
    let onToggle: () -> Void

    private var accentColor: Color { .presetAccent(for: preset.id) }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                // Цветная иконка сервиса
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(accentColor.opacity(preset.isEnabled ? 0.18 : 0.08))
                        .frame(width: 40, height: 40)

                    Image(systemName: preset.systemIconName)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(
                            preset.isEnabled
                                ? accentColor
                                : Color.textTertiary
                        )
                }
                .animation(.spring(response: 0.3), value: preset.isEnabled)

                // Название
                VStack(alignment: .leading, spacing: 2) {
                    Text(preset.name)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(.white)
                    Text(preset.strategyDescription)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.textTertiary)
                }

                Spacer()

                // Тоггл
                Toggle("", isOn: Binding(
                    get: { preset.isEnabled },
                    set: { _ in onToggle() }
                ))
                .tint(accentColor)
                .labelsHidden()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)

            if !isLast {
                Divider()
                    .background(Color.appSeparator)
                    .padding(.leading, 70)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SettingsView(viewModel: SettingsViewModel())
}
