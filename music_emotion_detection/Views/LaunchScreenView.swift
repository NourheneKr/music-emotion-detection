//
//  LaunchScreenView.swift
//  music_emotion_detection
//
//  Created by Nourhene Krichene on 22/07/2024.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Image("launch_bg")
                .resizable()
        }.edgesIgnoringSafeArea(.all)
    }
}
#Preview {
    LaunchScreenView()
}
