// ConnectButton.swift
// DPISwitch
//
// Главная кнопка подключения.
// Liquid Glass + многослойная пульсирующая анимация + иконка питания.

import SwiftUI

struct ConnectButton: View {

    let state: ConnectionState
    let action: () -> Void

    // MARK: - Анимационные переменные

    @State private var buttonScale: CGFloat = 1.0
    @State private var pulse1Scale: CGFloat = 1.0
    @State private var pulse1Opacity: Double = 0.0
    @State private var pulse2Scale: CGFloat = 1.0
    @State private var pulse2Opacity: Double = 0.0
    @State private var pulse3Scale: CGFloat = 1.0
    @State private var pulse3Opacity: Double = 0.0
    @State private var iconRotation: Double = 0.0
    @State private var innerGlowOpacity: Double = 0.0

    // MARK: - Computed Properties

    private var buttonColor: Color { Color.buttonColor(for: state) }
    private var isConnected: Bool { state.isActive }
    private var isTransitioning: Bool { state.isTransitioning }

    // Интенсивность свечения зависит от состояния
    private var glowRadius: CGFloat { isConnected ? 35 : 0 }
    private var glowOpacity: Double { isConnected ? 0.55 : 0.0 }

    // MARK: - Body

    var body: some View {
        ZStack {
            // Пульсирующие кольца (только когда подключено)
            pulseRings

            // Основная кнопка
            Button(action: handleTap) {
                ZStack {
                    // Liquid Glass основа
                    Circle()
                        .fill(buttonColor.opacity(0.85))
                        .frame(width: 200, height: 200)
                        .circleGlass(
                            tintColor: buttonColor,
                            glowRadius: glowRadius,
                            glowOpacity: glowOpacity
                        )

                    // Внутреннее свечение (дополнительный слой при connected)
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [buttonColor.opacity(innerGlowOpacity), .clear],
                                center: .center,
                                startRadius: 20,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .blendMode(.screen)

                    // Иконка питания
                    buttonIcon
                }
            }
            .buttonStyle(.plain)
            .scaleEffect(buttonScale)
            .animation(.spring(response: 0.35, dampingFraction: 0.65), value: buttonScale)
            .animation(.easeInOut(duration: 0.5), value: buttonColor)
            .disabled(isTransitioning)
        }
        .onChange(of: state) { _, newState in
            updateAnimations(for: newState)
        }
        .onAppear {
            updateAnimations(for: state)
        }
    }

    // MARK: - Компоненты

    private var buttonIcon: some View {
        ZStack {
            if isTransitioning {
                // Спиннер при подключении
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(1.8)
                    .transition(.opacity)
            } else {
                // Иконка питания
                Image(systemName: "power")
                    .font(.system(size: 60, weight: .ultraLight))
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(iconRotation))
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isTransitioning)
    }

    /// Три кольца с разной задержкой для эффекта пульса
    private var pulseRings: some View {
        ZStack {
            pulseRing(scale: pulse1Scale, opacity: pulse1Opacity)
            pulseRing(scale: pulse2Scale, opacity: pulse2Opacity)
            pulseRing(scale: pulse3Scale, opacity: pulse3Opacity)
        }
    }

    private func pulseRing(scale: CGFloat, opacity: Double) -> some View {
        Circle()
            .stroke(buttonColor, lineWidth: 1.5)
            .frame(width: 200, height: 200)
            .scaleEffect(scale)
            .opacity(opacity)
    }

    // MARK: - Действия

    private func handleTap() {
        // Тактильный отклик
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        // Spring-анимация нажатия
        withAnimation(.spring(response: 0.12, dampingFraction: 0.5)) {
            buttonScale = 0.92
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                buttonScale = 1.0
            }
        }

        action()
    }

    // MARK: - Управление анимациями

    private func updateAnimations(for newState: ConnectionState) {
        withAnimation(.easeInOut(duration: 0.4)) {
            innerGlowOpacity = newState.isActive ? 0.25 : 0.0
        }

        if newState.isActive {
            startPulseAnimation()
        } else {
            stopPulseAnimation()
        }
    }

    private func startPulseAnimation() {
        // Кольцо 1
        withAnimation(.easeOut(duration: 2.2).repeatForever(autoreverses: false)) {
            pulse1Scale = 1.8
            pulse1Opacity = 0.0
        }
        pulse1Opacity = 0.5

        // Кольцо 2 — с задержкой
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation(.easeOut(duration: 2.2).repeatForever(autoreverses: false)) {
                pulse2Scale = 1.8
                pulse2Opacity = 0.0
            }
            pulse2Opacity = 0.4
        }

        // Кольцо 3 — с большей задержкой
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            withAnimation(.easeOut(duration: 2.2).repeatForever(autoreverses: false)) {
                pulse3Scale = 1.8
                pulse3Opacity = 0.0
            }
            pulse3Opacity = 0.3
        }
    }

    private func stopPulseAnimation() {
        withAnimation(.easeInOut(duration: 0.3)) {
            pulse1Scale = 1.0; pulse1Opacity = 0.0
            pulse2Scale = 1.0; pulse2Opacity = 0.0
            pulse3Scale = 1.0; pulse3Opacity = 0.0
        }
    }
}

#Preview {
    ZStack {
        Color.black
        VStack(spacing: 40) {
            ConnectButton(state: .disconnected, action: {})
            ConnectButton(state: .connected, action: {})
        }
    }
}
