//
//  PredictionResponse.swift
//  music_emotion_detection
//
//  Created by Nourhene Krichene on 22/07/2024.
//

import Foundation

struct PredictionResult: Decodable {
    let emotion: String
    let emotion_emoji: String    
}

struct EmotionDetails {
    let title: String
    let description: String
    let image: String
}

enum EmotionEnum: String {
    case Neutral
    case Joy
    case Excitement
    case Euphoria
    case Satisfaction
    case Worry
    case Sadness
    case Anger
    case Disappointment
    case Distress
    case Dejection
    case Nostalgia
    case Apathy
    
    
    var details: EmotionDetails {
        switch self {
        case .Neutral:
            return EmotionDetails(
                title: "Neutral",
                description: "A calm state where the music doesn't evoke strong feelings.",
                image: "neutral_bg"
            )
        case .Joy:
            return EmotionDetails(
                title: "Joy",
                description: "Uplifting music that makes you feel happy and carefree.",
                image: "Joy_bg"
            )
        case .Excitement:
            return EmotionDetails(
                title: "Excitement",
                description: "Energetic beats that get your heart racing and keep you on your toes.",
                image: "Excitement-bg"
            )
        case .Euphoria:
            return EmotionDetails(
                title: "Euphoria",
                description: "Intense feelings of pleasure and happiness conveyed through the music.",
                image: "Euphoria-bg"
            )
        case .Satisfaction:
            return EmotionDetails(
                title: "Satisfaction",
                description: "Music that gives a sense of contentment and fulfillment.",
                image: "Satisfaction-bg"
            )
        case .Worry:
            return EmotionDetails(
                title: "Worry",
                description: "Music that evokes a sense of unease or apprehension.",
                image: "music-mood-anxious-stress-nervous-worried"
            )
        case .Sadness:
            return EmotionDetails(
                title: "Sadness",
                description: "Melancholic tunes that reflect feelings of sorrow and sadness.",
                image: "sadness_bg"
            )
        case .Anger:
            return EmotionDetails(
                title: "Anger",
                description: "Intense, aggressive music that channels frustration and anger.",
                image: "Anger-bg"
            )
        case .Disappointment:
            return EmotionDetails(
                title: "Disappointment",
                description: "Music that resonates with feelings of letdown and unfulfilled expectations.",
                image: "Disappointment-bg"
            )
        case .Distress:
            return EmotionDetails(
                title: "Distress",
                description: "Music that conveys a sense of severe anxiety or emotional pain.",
                image: "Distress-bg"
            )
        case .Dejection:
            return EmotionDetails(
                title: "Dejection",
                description: "Tunes that evoke a sense of deep disappointment or sadness.",
                image: "annoying"
            )
        case .Nostalgia:
            return EmotionDetails(
                title: "Nostalgia",
                description: "Music that brings back memories and a longing for the past.",
                image: "Nostalgia_bg"
            )
        case .Apathy:
            return EmotionDetails(
                title: "Apathy",
                description: "Indifferent music that doesn't elicit strong emotional responses.",
                image: "Apathy-bg"
            )
        }
    }
}

