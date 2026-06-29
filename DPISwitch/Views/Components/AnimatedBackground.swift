// AnimatedBackground.swift
// DPISwitch
//
// Анимированный фон — медленно движущиеся цветные блобы с blur.
// GPU-ускоренная анимация через SwiftUI + Core Animation.

import SwiftUI

struct AnimatedBackground: View {

    @State private var animate = false

    var body: some View {
        ZStack {
            // Базовый цвет — почти чёрный с синим оттенком
            Color(red: 0.02, green: 0.02, blue: 0.07)

            // Блоб 1 — фиолетовый, верхний левый
            blobView(
                color: Color(red: 0.35, green: 0.1, blue: 0.8),
                size: 380,
                xOffset: animate ? -100 : 60,
                yOffset: animate ? -180 : -80,
                blur: 110,
                duration: 9,
                delay: 0
            )

            // Блоб 2 — синий, правый центр
            blobView(
                color: Color(red: 0.0, green: 0.35, blue: 0.9),
                size: 320,
                xOffset: animate ? 120 : -40,
                yOffset: animate ? 60 : 160,
                blur: 100,
                duration: 11,
                delay: 1.5
            )

            // Блоб 3 — тёмно-синий, нижний левый
            blobView(
                color: Color(red: 0.05, green: 0.2, blue: 0.6),
                size: 280,
                xOffset: animate ? -80 : 40,
                yOffset: animate ? 220 : 100,
                blur: 90,
                duration: 13,
                delay: 3
            )

            // Блоб 4 — accent highlight, центр
            blobView(
                color: Color(red: 0.0, green: 0.5, blue: 1.0),
                size: 180,
                xOffset: animate ? 30 : -30,
                yOffset: animate ? -40 : 40,
                blur: 80,
                duration: 7,
                delay: 0.5
            )
        }
        .ignoresSafeArea()
        .onAppear { animate = true }
    }

    // MARK: - Вспомогательный метод

    private func blobView(
        color: Color,
        size: CGFloat,
        xOffset: CGFloat,
        yOffset: CGFloat,
        blur: CGFloat,
        duration: Double,
        delay: Double
    ) -> some View {
        Circle()
            .fill(color.opacity(0.18))
            .frame(width: size, height: size)
            .offset(x: xOffset, y: yOffset)
            .blur(radius: blur)
            .animation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: true)
                .delay(delay),
                value: animate
            )
    }
}

#Preview {
    AnimatedBackground()
}
