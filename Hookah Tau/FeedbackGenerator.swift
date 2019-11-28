//
//  FeedbackGenerator.swift
//  Dotrix
//
//  Created by Ilya Kos on 7/21/18.
//  Copyright © 2018 Ilya Kos. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

private let recourcesURL = Bundle.main.bundleURL
private let click1 = try! Data(contentsOf: recourcesURL.appendingPathComponent("click1.mp3"))
private let click2 = try! Data(contentsOf: recourcesURL.appendingPathComponent("click2.mp3"))
private let click3 = try! Data(contentsOf: recourcesURL.appendingPathComponent("click3.mp3"))

/// Структура, отвечающая за аудио отдачу приложения.
private struct AudioFeedback {
    static let light1 = try! AVAudioPlayer(data: click1, fileTypeHint: AVFileType.mp3.rawValue)
    static let light2 = try! AVAudioPlayer(data: click1, fileTypeHint: AVFileType.mp3.rawValue)
    static let medium1 = try! AVAudioPlayer(data: click2, fileTypeHint: AVFileType.mp3.rawValue)
    static let medium2 = try! AVAudioPlayer(data: click2, fileTypeHint: AVFileType.mp3.rawValue)
    static let heavy1 = try! AVAudioPlayer(data: click3, fileTypeHint: AVFileType.mp3.rawValue)
    static let heavy2 = try! AVAudioPlayer(data: click3, fileTypeHint: AVFileType.mp3.rawValue)
    static let delegate = RepeaterDelegate()
    static func initialize() {
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient, mode: AVAudioSession.Mode(rawValue: convertFromAVAudioSessionMode(AVAudioSession.Mode.default)), options: [])
        try? AVAudioSession.sharedInstance().setActive(true)
        let volume: Float = 0.04
        light1.volume = volume
        light2.volume = volume
        medium1.volume = volume
        medium2.volume = volume
        heavy1.volume = volume
        heavy2.volume = volume
        light1.prepareToPlay()
        light2.prepareToPlay()
        medium1.prepareToPlay()
        medium2.prepareToPlay()
        heavy1.prepareToPlay()
        heavy2.prepareToPlay()
        light1.delegate = delegate
        light2.delegate = delegate
        medium1.delegate = delegate
        medium2.delegate = delegate
        heavy1.delegate = delegate
        heavy2.delegate = delegate
    }
}

private class RepeaterDelegate: NSObject, AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.currentTime = 0
        player.prepareToPlay()
    }
}

/// Структура, отвечающая за аудио и тактильную отдачу приложения.
struct FeedbackGenerator {
    static func initialize() {
        AudioFeedback.initialize()
    }
    
    enum Style {
        case extraLight
        case light
        case medium
        case heavy
    }
    
    private static let extraLightImpactGenerator = UISelectionFeedbackGenerator()
    private static let lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
    private static let mediumImpactGenerator = UIImpactFeedbackGenerator(style: .medium)
    private static let heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)

    static func prepare(for style: Style) {
        switch style {
        case .extraLight:
            extraLightImpactGenerator.prepare()
            AudioFeedback.light1.prepareToPlay()
            AudioFeedback.light2.prepareToPlay()
        case .light:
            lightImpactGenerator.prepare()
            AudioFeedback.light1.prepareToPlay()
            AudioFeedback.light2.prepareToPlay()
        case .medium:
            mediumImpactGenerator.prepare()
            AudioFeedback.medium1.prepareToPlay()
            AudioFeedback.medium2.prepareToPlay()
        case .heavy:
            heavyImpactGenerator.prepare()
            AudioFeedback.heavy1.prepareToPlay()
            AudioFeedback.heavy2.prepareToPlay()
        }
    }
    
    private static var soundCounter = 0
    static func play(style: Style) {
        OperationQueue.main.addOperation {
            var player: AVAudioPlayer!
            var generator: Impactable!
            switch style {
            case .extraLight:
                generator = extraLightImpactGenerator
                player = soundCounter == 0 ? AudioFeedback.light1 : AudioFeedback.light2
            case .light:
                generator = lightImpactGenerator
                player = soundCounter == 0 ? AudioFeedback.light1 : AudioFeedback.light2
            case .medium:
                generator = mediumImpactGenerator
                player = soundCounter == 0 ? AudioFeedback.medium1 : AudioFeedback.medium2
            case .heavy:
                generator = heavyImpactGenerator
                player = soundCounter == 0 ? AudioFeedback.heavy1 : AudioFeedback.heavy2
            }
            if player.isPlaying {
                player.currentTime = 0
            } else {
                player.play()
            }
            generator.impactOccurred()
            soundCounter = (soundCounter + 1)%2
        }
    }
}

protocol Impactable {
    func impactOccurred()
}

extension UISelectionFeedbackGenerator: Impactable {
    func impactOccurred() {
        selectionChanged()
    }
}

extension UIImpactFeedbackGenerator: Impactable {}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionMode(_ input: AVAudioSession.Mode) -> String {
	return input.rawValue
}
