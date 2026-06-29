// View+GlassEffect.swift
// DPISwitch
//
// Liquid Glass — кастомная реализация через ultraThinMaterial.
// Работает на iOS 17+ включая iOS 26.
// Выглядит идентично системному glass Apple.

import SwiftUI

// MARK: - Liquid Glass ViewModifier (карточки, кнопки)

struct LiquidGlassModifier: ViewModifier {

    var cornerRadius: CGFloat
    var tintColor: Color
    var tintOpacity: Double
    var strokeOpacity: Double

    func body(content: Content) -> some View {
        content
            .background(glassBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(specularStroke(cornerRadius: cornerRadius))
            .shadow(color: tintColor.opacity(0.08), radius: 20, x: 0, y: 10)
    }

    // Многослойный фон: blur + тинт + тёмная подложка
    private var glassBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(tintColor.opacity(tintOpacity))
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color.black.opacity(0.25))
        }
    }

    // Specular highlight — имитирует преломление света на стекле
    private func specularStroke(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(
                LinearGradient(
                    colors: [
                        Color.white.opacity(strokeOpacity),
                        Color.white.opacity(strokeOpacity * 0.3),
                        Color.clear,
                        Color.white.opacity(strokeOpacity * 0.15)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 0.8
            )
    }
}

// MARK: - Circle Glass (для кнопки подключения)

struct CircleGlassModifier: ViewModifier {

    var tintColor: Color
    var glowRadius: CGFloat
    var glowOpacity: Double

    func body(content: Content) -> some View {
        content
            .background(circleBackground)
            .clipShape(Circle())
            .overlay(circleStroke)
            .shadow(color: tintColor.opacity(glowOpacity), radius: glowRadius, x: 0, y: 0)
            .shadow(color: tintColor.opacity(glowOpacity * 0.4), radius: glowRadius * 2.2, x: 0, y: 0)
    }

    private var circleBackground: some View {
        ZStack {
            Circle().fill(.ultraThinMaterial)
            Circle().fill(tintColor.opacity(0.12))
            Circle().fill(Color.black.opacity(0.28))
        }
    }

    private var circleStroke: some View {
        Circle()
            .stroke(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.35),
                        Color.white.opacity(0.05),
                        Color.clear,
                        Color.white.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1.0
            )
    }
}

// MARK: - View Extensions

extension View {

    /// Liquid Glass карточка (для секций, списков)
    func liquidGlass(
        cornerRadius: CGFloat = 20,
        tintColor: Color = .blue,
        tintOpacity: Double = 0.04,
        strokeOpacity: Double = 0.25
    ) -> some View {
        modifier(LiquidGlassModifier(
            cornerRadius: cornerRadius,
            tintColor: tintColor,
            tintOpacity: tintOpacity,
            strokeOpacity: strokeOpacity
        ))
    }

    /// Liquid Glass круг (для кнопки подключения)
    func circleGlass(
        tintColor: Color = .blue,
        glowRadius: CGFloat = 0,
        glowOpacity: Double = 0
    ) -> some View {
        modifier(CircleGlassModifier(
            tintColor: tintColor,
            glowRadius: glowRadius,
            glowOpacity: glowOpacity
        ))
    }
}
