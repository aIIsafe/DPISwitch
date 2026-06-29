// HomeView.swift
// DPISwitch
//
// Главный экран приложения.
// Большая круглая кнопка по центру + кнопка Settings внизу.
//
// Совместимость: iOS 15+ (Xcode 13 / Big Sur)

import SwiftUI

struct HomeView: View {

    // MARK: - Зависимости

    @StateObject private var connectionVM: ConnectionViewModel
    @StateObject private var settingsVM: SettingsViewModel

    // MARK: - Анимационное состояние

    /// Масштаб кнопки при нажатии (spring-анимация)
    @State private var buttonScale: CGFloat = 1.0

    /// Показывать ли экран настроек
    @State private var showSettings = false

    // MARK: - Инициализация

    init() {
        let settings = SettingsViewModel()
        _settingsVM = StateObject(wrappedValue: settings)
        _connectionVM = StateObject(wrappedValue: ConnectionViewModel(settingsViewModel: settings))
    }

    // MARK: - Тело

    var body: some View {
        // NavigationView для совместимости с iOS 15 / Xcode 13
        NavigationView {
            ZStack {
                // Фон
                Color.appBackground
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    // Большая круглая кнопка
                    connectButton

                    // Статус текст
                    statusLabel
                        .padding(.top, 28)

                    Spacer()

                    // Кнопка Settings внизу
                    settingsButton
                        .padding(.bottom, 48)
                }
            }
            .navigationBarHidden(true)
            .alert(
                "Error",
                isPresented: Binding(
                    get: { connectionVM.errorMessage != nil },
                    set: { if !$0 { connectionVM.errorMessage = nil } }
                )
            ) {
                Button("OK", role: .cancel) {
                    connectionVM.errorMessage = nil
                }
            } message: {
                Text(connectionVM.errorMessage ?? "")
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(viewModel: settingsVM)
            }
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - Компоненты

    /// Большая круглая кнопка подключения
    private var connectButton: some View {
        let state = connectionVM.connectionState
        let buttonColor = Color.buttonColor(for: state)
        let isConnected = state.isActive

        return Button(action: handleButtonTap) {
            ZStack {
                // Основной круг
                Circle()
                    .fill(buttonColor)
                    .frame(width: 180, height: 180)

                // Иконка питания (SF Symbols)
                Image(systemName: "power")
                    .font(.system(size: 56, weight: .thin))
                    .foregroundColor(.white)
                    .opacity(state.isTransitioning ? 0.5 : 1.0)

                // Спиннер во время подключения
                if state.isTransitioning {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
            }
        }
        .buttonStyle(.plain)
        // Spring-анимация при нажатии
        .scaleEffect(buttonScale)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: buttonScale)
        // Плавная смена цвета
        .animation(.easeInOut(duration: 0.4), value: state)
        // Пульс когда подключено
        .pulseAnimation(color: buttonColor, isActive: isConnected)
        .disabled(state.isTransitioning)
    }

    /// Текст статуса под кнопкой
    private var statusLabel: some View {
        VStack(spacing: 6) {
            Text(connectionVM.connectionState.displayTitle)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
                .animation(.easeInOut(duration: 0.3), value: connectionVM.connectionState)

            // Адрес прокси — показываем только когда подключено
            if connectionVM.connectionState.isActive {
                Text(connectionVM.proxyAddress)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .font(.system(.caption, design: .monospaced))
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: connectionVM.connectionState)
    }

    /// Кнопка Settings
    private var settingsButton: some View {
        Button(action: { showSettings = true }) {
            Text("Settings")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.textSecondary)
                .frame(width: 200, height: 44)
                .background(Color.appSurface)
                .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Действия

    private func handleButtonTap() {
        // Анимация нажатия
        withAnimation(.spring(response: 0.15, dampingFraction: 0.5)) {
            buttonScale = 0.93
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                buttonScale = 1.0
            }
        }

        // Тактильная обратная связь
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()

        // Переключение подключения
        connectionVM.toggleConnection()
    }
}

// MARK: - Preview

// Xcode 13 использует PreviewProvider вместо #Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}
