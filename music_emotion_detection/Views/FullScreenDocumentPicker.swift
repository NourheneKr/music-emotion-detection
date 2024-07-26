//
//  FullScreenDocumentPicker.swift
//  music_emotion_detection
//
//  Created by Nourhene Krichene on 22/07/2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct FullScreenDocumentPicker: UIViewControllerRepresentable {
    let completion: (Result<URL, Error>) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio], asCopy: true)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: FullScreenDocumentPicker

        init(_ parent: FullScreenDocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else {
                parent.completion(.failure(NSError(domain: "DocumentPicker", code: 1, userInfo: [NSLocalizedDescriptionKey: "No document selected"])))
                return
            }
            parent.completion(.success(url))
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.completion(.failure(NSError(domain: "DocumentPicker", code: 2, userInfo: [NSLocalizedDescriptionKey: "Document picker was cancelled"])))
        }
    }
}
