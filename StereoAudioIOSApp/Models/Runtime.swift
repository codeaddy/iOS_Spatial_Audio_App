//
//  Runtime.swift
//  StereoAudioIOSApp
//
//  Created by Владислав Сизикин.
//

import Foundation

class Runtime {
    public var player:AudioPlayerWrapper
    
    init() {
        self.player = AudioPlayerWrapper()
    }
    
    public func playAudioFile(_ audioFile:AudioFile) {
        self.player.playAudioFile(audioFile)
    }
    
    public func stopPlaying() {
        self.player.stopPlaying()
    }
}
