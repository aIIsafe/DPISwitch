// View+PulseAnimation.swift
// DPISwitch
//
// ViewModifier для пульсирующей анимации кнопки подключения.
// Используется в HomeView для визуальной обратной связи.

import SwiftUI

// MARK: - Pulse ViewModifier

/// Добавляет пульсирующее свечение вокруг вью
struct PulseAnimationModifier: ViewModifier {

    let color: Color
    let isActive: Bool

    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.6

    func body(content: Content) -> some View {
        content
            .overlay(
                Circle()
                    .stroke(color, lineWidth: 2)
                    .scaleEffect(scale)
                    .opacity(isActive ? opacity : 0)
                    .animation(
                        isActive
                            ? .easeOut(duration: 1.4).repeatForever(autoreverses: false)
                            : .default,
                        value: scale
                    )
            )
            .overlay(
                Circle()
                    .stroke(color, lineWidth: 1)
                    .scaleEffect(scale * 1.2)
                    .opacity(isActive ? opacity * 0.4 : 0)
                    .animation(
                        isActive
                            ? .easeOut(duration: 1.4).repeatForever(autoreverses: false).delay(0.3)
                            : .default,
                        value: scale
                    )
            )
            .onChange(of: isActive) { _, active in
                if active {
                    scale = 1.5
                    opacity = 0.0
                } else {
                    scale = 1.0
                    opacity = 0.6
                }
            }
            .onAppear {
                if isActive {
                    scale = 1.5
                    opacity = 0.0
                }
            }
    }
}

// MARK: - View Extension

extension View {

    /// Применяет пульсирующую анимацию
    /// - Parameters:
    ///   - color: Цвет пульса
    ///   - isActive: Активна ли анимация
    func pulseAnimation(color: Color, isActive: Bool) -> some View {
        modifier(PulseAnimationModifier(color: color, isActive: isActive))
    }
}
