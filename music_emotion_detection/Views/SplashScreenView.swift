//
//  SplashScreenView.swift
//  music_emotion_detection
//
//  Created by Nourhene Krichene on 22/07/2024.
//

import SwiftUI

struct LoaderView: View {
    @State private var isAnimating = false
    
    @State private var animationAmount: CGFloat = 1.0
    private let messages = [
            "Extracting data...",
            "Compiling results...",
            "Analyzing...",
            "Please wait..."
    ]
    @State private var currentMessageIndex = 0

    var body: some View {
        VStack {
            HStack {
                ForEach(0..<5) { index in
                    WaveShape()
                        .fill(Color.purple)
                        .frame(width: 20, height: 100)
                        .scaleEffect(animationAmount)
                        .animation(
                            Animation.easeInOut(duration: 0.8)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                            value: animationAmount
                        )
                }
            }
            Text(messages[currentMessageIndex])
                .foregroundColor(Color.purple)
                .padding(.top, 24)
        }
        .onAppear {
            animationAmount = 0.5
            startMessageRotation()
        }
    }
    private func startMessageRotation() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            withAnimation {
                currentMessageIndex = (currentMessageIndex + 1) % messages.count
            }
        }
    }

}

/*
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(Color.purple, lineWidth: 5)
            .frame(width: 50, height: 50)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
            .onAppear {
                self.isAnimating = true
            }
 */
    
struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let numberOfWaves = 2
        let waveWidth = rect.width / CGFloat(numberOfWaves)
        let amplitude: CGFloat = 10
        
        path.move(to: CGPoint(x: 0, y: rect.height / 2))
        
        for i in 0...numberOfWaves {
            let x = CGFloat(i) * waveWidth
            let y = amplitude * sin(2 * .pi * (x / rect.width)) + (rect.height / 2)
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

struct MusicNoteLoader: View {
    @State private var isAnimating = false

    var body: some View {
        VStack {
            Image(systemName: "music.note")
                .resizable()
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
            
            Text("Prédiction en cours...")
                .foregroundColor(.white)
                .padding(.top, 10)
        }
    }
}

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                Text("Chargement...")
                    .font(.title)
                    .padding(.top, 20)
            }
        }
    }
}
