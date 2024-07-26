//
//  ContentView.swift
//  music_emotion_detection
//
//  Created by Nourhene Krichene on 22/07/2024.
//

import SwiftUI
import AVFoundation
import Foundation

struct ContentView: View {
    @StateObject private var audioRecorder = AudioRecorder()
    
    @State private var showDocumentPicker = false
    @State private var isRecording = false
    @State private var isLoading = false
    @State private var audioURL: URL?
    @State private var emotionResult: String?
    @State private var emotionEmoji: String?
    @State private var showResult = false
    
    @State private var animationDots = ""
    @State private var errorMessage: String?
    @State private var audioPlayerReset = false
    @State private var showAudioPlayer = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                if !isLoading {
                    
                    VStack {
                        Text("♬ Music Emotion Detector")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top)
                        
                        VStack {
                            
                            VStack(spacing: 20) {
                                Text("Upload or Record Music")
                                    .frame(maxWidth: .infinity)
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Button(action: selectFromDevice) {
                                    Text("Select from Device")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.purple)
                                        .foregroundColor(.white)
                                        .cornerRadius(40)
                                        .font(.system(size: 18))
                                }
                                
                                Button(action: {
                                    if audioRecorder.isRecording {
                                        audioRecorder.stopRecording()
                                        animationDots = ""
                                    } else {
                                        audioRecorder.startRecording()
                                        animateDots()
                                    }
                                }) {
                                    Text(audioRecorder.isRecording ? "Recording\(animationDots)" : "Record Audio")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.purple)
                                        .foregroundColor(.white)
                                        .cornerRadius(40)
                                        .font(.system(size: 18))
                                }.padding(.bottom, 32)
                            }
                            .padding(24)
                        }.background(Color.gray.opacity(0.6)).cornerRadius(8)
                        
                        VStack {
                            Button(action: {
                                predict(fileURL: audioURL)
                            }) {
                                Text("Find Emotion")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(audioURL == nil ? Color.gray : Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(40)
                                    .font(.system(size: 18))
                            }
                            .disabled(audioURL == nil)
                            .padding(24)
                        }.background(Color.gray.opacity(0.6)).cornerRadius(8)
                        
                        Spacer()
                        
                        if showAudioPlayer, let audioURL = audioURL {
                            AdvancedAudioPlayerView(audioURL: audioURL, reset: $audioPlayerReset, isLoading: $isLoading)
                                .padding(.bottom, 20)
                        }
                        
                        Spacer()
                        
                    }.padding(.horizontal)
                } else {
                    LoaderView()
                }

                NavigationLink(destination: EmotionView(emotion: emotionResult ?? "", emoji: emotionEmoji ?? ""), isActive: $showResult) {
                    EmptyView()
                }
            }
        }/*.navigationDestination(isPresented: $showResult) {
            EmotionView(emotion: emotionResult ?? "", emoji: emotionEmoji ?? "")
        }*/.fullScreenCover(isPresented: $showDocumentPicker) {
            FullScreenDocumentPicker { result in
                switch result {
                case .success(let url):
                    self.uploadAudio(from: url)
                case .failure(let error):
                    self.errorMessage = "Error selecting file: \(error.localizedDescription)"
                }
            }
            
        }.onReceive(audioRecorder.$recordingFinished) { finished in
            if finished, let url = audioRecorder.audioFileURL {
                uploadRecordedAudio(fileURL: url)
            }
        }.onChange(of: isLoading) { newValue in
            if newValue {
                audioPlayerReset = true
            }
        }
    }
    
    func animateDots() {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            if self.animationDots.count < 3 {
                self.animationDots += "."
            } else {
                self.animationDots = ""
            }
        }
        timer.fire()
    }
    
    func selectFromDevice() {
        showDocumentPicker = true
    }
    
    func uploadRecordedAudio(fileURL: URL) {
        print("Uploading audio file from URL: \(fileURL)")
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("Error: File does not exist at path: \(fileURL.path)")
            return
        }
        audioURL = fileURL
        if showAudioPlayer {
            audioPlayerReset.toggle()
        }
        showAudioPlayer = true
    }
    
    func uploadAudio(from sourceURL: URL) {
        print("Uploading audio file from URL: \(sourceURL)")
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsDirectory.appendingPathComponent(sourceURL.lastPathComponent)
        
        do {
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            try fileManager.copyItem(at: sourceURL, to: destinationURL)
            audioURL = destinationURL
            if showAudioPlayer {
                audioPlayerReset.toggle()
            }
            showAudioPlayer = true

        } catch {
            self.errorMessage = "Error copying file: \(error.localizedDescription)"
            print("Error copying file: \(error)")
            print(errorMessage)
        }
    }
    
    func predict(fileURL: URL?) {
        isLoading = true

        guard let url = URL(string: Constants.BASE_URL + "/predict"),
              let fileURL = fileURL
        else {
            isLoading = false
            return
        }
        
        print("Sending request to: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        let mimeType = "audio/mpeg"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        let filename = fileURL.lastPathComponent

        do {
            let fileData = try Data(contentsOf: fileURL)
            
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"audio\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            data.append(fileData)
            data.append("\r\n".data(using: .utf8)!)
            data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        } catch {
            print("Error reading file data: \(error)")
            self.errorMessage = "Error reading file data: \(error.localizedDescription)"
            isLoading = false
            print(errorMessage)
            return
        }
        
        let task = URLSession.shared.uploadTask(with: request, from: data) { responseData, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            if let error = error {
                print("Error uploading file: \(error)")
                self.errorMessage = "Error uploading file: \(error.localizedDescription)"
                print(errorMessage)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let statusCodeError = NSError(domain: "HTTPError", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])
                self.errorMessage = "Invalid response from server: \(statusCodeError.localizedDescription)"
                print(errorMessage)
                return
            }
            
            guard let responseData = responseData else {
                print("No data in response")
                self.errorMessage = "No data in response"
                return
            }
            
            do {
                let result = try JSONDecoder().decode(PredictionResult.self, from: responseData)
                DispatchQueue.main.async {
                    self.emotionResult = result.emotion
                    self.emotionEmoji = result.emotion_emoji
                    self.showResult = true
                    print(result)
                }
            } catch {
                print("Failed to decode JSON: \(error)")
                self.errorMessage = "Failed to decode JSON: \(error.localizedDescription)"
                if let jsonString = String(data: responseData, encoding: .utf8) {
                    print("Received JSON: \(jsonString)")
                }
            }
        }
        task.resume()
    }
}


#Preview {
    ContentView()
}
