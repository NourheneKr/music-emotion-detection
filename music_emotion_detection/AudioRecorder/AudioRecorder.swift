//
//  AudioRecorder.swift
//  music_emotion_detection
//
//  Created by Nourhene Krichene on 22/07/2024.
//

import SwiftUI
import AVFoundation


class AudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate {
    @Published var isRecording = false
    @Published var recordingFinished = false
    var audioRecorder: AVAudioRecorder?
    var audioFileURL: URL?

    func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    func startRecording() {
        setupAudioSession()
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.wav")
        audioFileURL = audioFilename

        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsFloatKey: false,
            AVLinearPCMIsBigEndianKey: false,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ] as [String : Any]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            if audioRecorder?.record() == false {
                print("Recording failed to start")
            } else {
                isRecording = true
                recordingFinished = false
            }
        } catch {
            print("Could not start recording: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        recordingFinished = true
    }

    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordingFinished = true
            print("Recording Finished with success")
        } else {
            print("Recording failed")
        }
    }
    
}
