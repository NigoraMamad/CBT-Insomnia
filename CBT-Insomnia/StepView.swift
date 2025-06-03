//
//  StepView.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 27/05/25.
//

import SwiftUI

struct StepView: View {
    @StateObject private var stepCounter = StepCounter()
    @State private var animate = false
    @State private var showConfetti = false
    @State private var fakeProgress: Double = 0
    @State private var isWaitingForRealSteps = false

    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                Text("🚶 Steps Taken")
                    .font(.title2)
                    .bold()

                Text("\(stepCounter.stepCount)")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.blue)
                    .scaleEffect(animate ? 1.1 : 1.0)
                    .animation(stepCounter.isTracking ? .easeInOut(duration: 0.6).repeatForever(autoreverses: true) : .default, value: animate)
                    .onAppear { animate = true }

                // Friendly tracking message
                if stepCounter.isTracking {
                    VStack(spacing: 10) {
                        Text("Keep walking, I’ll let you know when you reach more than 10 steps 🚶")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal)

                        HStack(spacing: 8) {
                            ForEach(0..<3) { i in
                                DotView(delay: Double(i) * 0.3)
                            }
                        }
                    }
                }

                // 🔘 Buttons
                if stepCounter.isTracking {
                    Button("Stop Tracking") {
                        stepCounter.stopTracking()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Reset") {
                        withAnimation {
                            stepCounter.reset()
                            showConfetti = false
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                } else {
                    Button("Start Tracking") {
                        stepCounter.startTracking()
                        fakeProgress = 0
                        isWaitingForRealSteps = true

                        // UX animation (optional: keep for fake responsiveness)
                        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                            fakeProgress += 0.2
                            if fakeProgress >= 2.0 || stepCounter.stepCount > 0 {
                                timer.invalidate()
                                isWaitingForRealSteps = false
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
            }
            .padding()
            .alert(isPresented: $stepCounter.showGoalReachedAlert) {
                Alert(
                    title: Text("🎉 Goal Reached"),
                    message: Text("You took more than 10 steps! Tracking stopped."),
                    dismissButton: .default(Text("OK"), action: {
                        withAnimation {
                            showConfetti = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                withAnimation {
                                    showConfetti = false
                                }
                            }
                        }
                    })
                )
            }

            // 🎊 Confetti Celebration
            if showConfetti {
                ForEach(0..<20, id: \.self) { i in
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor([.red, .yellow, .green, .blue, .purple].randomElement()!)
                        .position(
                            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                            y: CGFloat.random(in: 0...UIScreen.main.bounds.height / 2)
                        )
                        .opacity(Double.random(in: 0.5...1))
                        .transition(.scale)
                        .animation(.easeOut(duration: 1.2).delay(Double(i) * 0.03), value: showConfetti)
                }
            }
        }
    }
}
