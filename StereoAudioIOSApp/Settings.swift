//
//  Settings.swift
//  StereoAudioIOSApp
//
//  Created by Владислав Сизикин on 08.05.2023.
//

import Foundation
import AVFoundation

enum KeysUserDefaults {
    static let settingsRuntime = "settingsRuntime"
}

struct SettingsRuntime:Codable {
    var selectedAudioFile:AudioFile = AudioFile(name: "", filePath: "", type: .ASMR)
    
    var listenerX:Float = 0
    var listenerY:Float = 0
    var listenerZ:Float = 0
    
    var vectorX:Float = 0
    var vectorY:Float = 0
    var vectorZ:Float = 0
    
    var reverbType:Int = -1
    var reverbMix:Float = 0
}

class ProjectSettings {
    static var shared = ProjectSettings()
    
    let defaultSettings = SettingsRuntime()
    
    var currentSettings:SettingsRuntime {
        get {
            print("enterred currentSettings getter")
//            UserDefaults.standard.removeObject(forKey: KeysUserDefaults.settingsRuntime)
            
            if let data = UserDefaults.standard.object(forKey: KeysUserDefaults.settingsRuntime) as? Data {
                print("we're trying to decode")
                return try! PropertyListDecoder().decode(SettingsRuntime.self, from: data)
            }
            else {
                if let data = try? PropertyListEncoder().encode(defaultSettings) {
                    UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settingsRuntime)
                }
                return defaultSettings
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settingsRuntime)
            }
        }
    }
}
