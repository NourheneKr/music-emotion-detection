//
//  AdvancedAudioPlayerView.swift
//  music_emotion_detection
//
//  Created by Nourhene Krichene on 24/07/2024.
//

import SwiftUI
import AVFoundation

struct AdvancedAudioPlayerView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var progress: Double = 0
    @State private var duration: Double = 0
    private let audioURL: URL
    @Binding var reset: Bool
    @Binding var isLoading: Bool

    init(audioURL: URL, reset: Binding<Bool>, isLoading: Binding<Bool>) {
        self.audioURL = audioURL
        self._reset = reset
        self._isLoading = isLoading
    }

    var body: some View {
        VStack {
            Button(action: togglePlayPause) {
                Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            }

            Slider(value: $progress, in: 0...duration) { editing in
                if !editing {
                    audioPlayer?.currentTime = progress
                }
            }

            HStack {
                Text(formatTime(progress))
                Spacer()
                Text(formatTime(duration))
            }
        }
        .padding()
        .onChange(of: reset) { newValue in
            audioPlayer?.stop()
            audioPlayer = nil
            isPlaying = false
            progress = 0
            setupAudioPlayer()
        }
        .onChange(of: isLoading) { newValue in
            if newValue {
                audioPlayer?.pause()
                isPlaying = false
            }
        }
        .onAppear {
            setupAudioPlayer()
        }
    }

    private func setupAudioPlayer() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.prepareToPlay()
            duration = audioPlayer?.duration ?? 0
            
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                if let player = audioPlayer {
                    progress = player.currentTime
                }
            }
        } catch {
            print("Error setting up audio player: \(error.localizedDescription)")
        }
    }

    private func togglePlayPause() {
        if let player = audioPlayer {
            if player.isPlaying {
                player.pause()
                isPlaying = false
            } else {
                player.play()
                isPlaying = true
            }
        }
    }

    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
