// HomeView.swift
// DPISwitch
//
// Главный экран. Liquid Glass дизайн.
// iOS 17+ / @Observable

import SwiftUI

struct HomeView: View {

    // MARK: - ViewModels (iOS 17 @Observable)

    @State private var settingsVM = SettingsViewModel()
    @State private var connectionVM: ConnectionViewModel

    // MARK: - UI State

    @State private var showSettings = false
    @State private var statusScale: CGFloat = 0.8
    @State private var statusOpacity: Double = 0.0

    // MARK: - Инициализация

    init() {
        let settings = SettingsViewModel()
        _settingsVM = State(initialValue: settings)
        _connectionVM = State(initialValue: ConnectionViewModel(settingsVM: settings))
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            // Анимированный фон
            AnimatedBackground()

            // Контент
            VStack(spacing: 0) {
                // Лого / заголовок
                headerView
                    .padding(.top, 60)

                Spacer()

                // Главная кнопка
                ConnectButton(
                    state: connectionVM.connectionState,
                    action: { connectionVM.toggleConnection() }
                )

                // Статус блок
                statusBlock
                    .padding(.top, 36)
                    .scaleEffect(statusScale)
                    .opacity(statusOpacity)

                Spacer()

                // Кнопка Settings
                settingsButton
                    .padding(.bottom, 50)
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
        // Алёрт при ошибке
        .alert(
            "Connection Error",
            isPresented: Binding(
                get: { connectionVM.errorMessage != nil },
                set: { if !$0 { connectionVM.errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) { connectionVM.errorMessage = nil }
        } message: {
            Text(connectionVM.errorMessage ?? "")
        }
        // Экран настроек
        .sheet(isPresented: $showSettings) {
            SettingsView(viewModel: settingsVM)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
                statusScale = 1.0
                statusOpacity = 1.0
            }
        }
    }

    // MARK: - Компоненты

    /// Заголовок приложения
    private var headerView: some View {
        VStack(spacing: 4) {
            Text("DPI Switch")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.9))
                .tracking(0.5)
        }
    }

    /// Блок статуса под кнопкой
    private var statusBlock: some View {
        VStack(spacing: 10) {
            // Основной статус
            Text(connectionVM.connectionState.displayTitle)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.4), value: connectionVM.connectionState)

            // Адрес прокси — только при connected
            if connectionVM.connectionState.isActive {
                proxyAddressView
                    .transition(.move(edge: .top).combined(with: .opacity))
            }

            // Статус активных пресетов
            activePresetsLabel
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: connectionVM.connectionState)
    }

    /// Адрес прокси в стиле glass pill
    private var proxyAddressView: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color.buttonActive)
                .frame(width: 6, height: 6)
                .shadow(color: .buttonActive, radius: 4)

            Text(connectionVM.proxyAddress)
                .font(.system(size: 13, weight: .medium, design: .monospaced))
                .foregroundStyle(Color.textSecondary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 7)
        .liquidGlass(cornerRadius: 20, tintColor: .buttonActive, tintOpacity: 0.06)
    }

    /// Подсказка с активными пресетами
    private var activePresetsLabel: some View {
        let enabled = settingsVM.presets.filter(\.isEnabled)
        let text: String

        if enabled.isEmpty {
            text = "No services selected"
        } else if enabled.count == 1 {
            text = enabled[0].name
        } else {
            text = enabled.map(\.name).joined(separator: " · ")
        }

        return Text(text)
            .font(.system(size: 13, weight: .regular, design: .rounded))
            .foregroundStyle(Color.textTertiary)
            .padding(.top, 2)
    }

    /// Кнопка Settings (Liquid Glass pill)
    private var settingsButton: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            showSettings = true
        }) {
            HStack(spacing: 8) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 15, weight: .medium))
                Text("Settings")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(Color.textSecondary)
            .padding(.horizontal, 28)
            .padding(.vertical, 14)
            .liquidGlass(cornerRadius: 24, tintColor: .white, tintOpacity: 0.03)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    HomeView()
}
