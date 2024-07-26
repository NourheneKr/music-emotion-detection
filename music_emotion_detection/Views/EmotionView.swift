//
//  EmotionView.swift
//  music_emotion_detection
//
//  Created by Nourhene Krichene on 22/07/2024.
//

import SwiftUI

struct EmotionView: View {
    let emotion: String
    let emoji: String
    
    var emotionDetails: EmotionDetails { (EmotionEnum(rawValue: emotion) ?? .Neutral).details }

    @State private var showShareSheet = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            
            ZStack{
                Image(emotionDetails.image)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                Color.black.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
                GeometryReader { geometry in
                    
                    VStack {
                        Text("Your Music Emotion")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                        
                        Text(emoji)
                            .font(.system(size: 100))
                            .padding()
                        
                        Text(emotionDetails.title)
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.bottom, 12)
                        
                        Text(emotionDetails.description)
                            .frame(width: 330)
                            .multilineTextAlignment(.center)
                            .font(.body)
                            .foregroundColor(.white)
                            .padding(.bottom, 50)

                        Button(action: {
                            showShareSheet = true
                        }) {
                            Text("Share Result 🎷")
                                .frame(width: 300)
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }.padding(.bottom, 20)
                        .sheet(isPresented: $showShareSheet) {
                            ShareSheet(items: ["I just analyzed a song and it made me feel \(emotionDetails.title) \(emoji)"])
                        }
                        
                        Button(action: backToMusicView) {
                            Text("Try another Music 😎")
                                .frame(width: 300)
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                    }.frame(width: geometry.size.width, height: geometry.size.height)//.padding()
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    private func backToMusicView() {
        presentationMode.wrappedValue.dismiss()
    }
}


#Preview {
    EmotionView(emotion: "Amusing", emoji: "😆")
}
