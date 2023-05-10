//
//  AudioFile.swift
//  StereoAudioIOSApp
//
//  Created by Владислав Сизикин.
//

import Foundation

struct AudioFile:Codable {
    let name: String
    let filePath: String
    let type: SoundType
}

enum SoundType:String, Codable {
    case ASMR = "ASMR"
    case Nature = "Nature"
    case Music = "Music"
    case SingleSounds = "SingleSounds"
}
