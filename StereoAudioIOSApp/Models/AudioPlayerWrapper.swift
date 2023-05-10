//
//  AudioPlayerWrapper.swift
//  StereoAudioIOSApp
//
//  Created by Владислав Сизикин.
//

import SoundpipeAudioKit
import AudioKitEX
import AVFoundation
import Foundation
import AudioKit
import CoreMotion

class AudioPlayerWrapper {
    private let player = AudioPlayer()
    private var reverb: Reverb
    private let engine = AudioEngine()
    private var audioFiles:[String:[AudioFile]] = [:]
    
    private var totalMixer = Mixer()
    
    private var source1mixer3D = Mixer3D(name: "3DMixer")
    private var environmentalNode = EnvironmentalNode()
    
    private let audioFolders = ["ASMR", "Nature", "Music", "SingleSounds"]
    private let fm = FileManager.default
    private let SAMPLES_PATH = Bundle.main.resourcePath! + "/Samples"
    private let reverbTypes:[AVAudioUnitReverbPreset] = [.largeHall, .cathedral, .plate, .smallRoom]
    
    private let autoPanner: AutoPanner
    private let dryWetMixerPanner: DryWetMixer
    private let dryWetMixerReverb: DryWetMixer
    
    var AudioFiles:[String:[AudioFile]] {
        get {
            return audioFiles
        }
    }
    
    init() {
        do {
            Settings.bufferLength = .short
            try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(Settings.bufferLength.duration)
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord,
                                                            options: [.defaultToSpeaker, .mixWithOthers, .allowBluetoothA2DP])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let err {
            print(err)
        }
        
        player.isLooping = true
        
        source1mixer3D.addInput(player)
        source1mixer3D.pointSourceInHeadMode = .mono
        environmentalNode.renderingAlgorithm = .HRTFHQ
        environmentalNode.reverbParameters.loadFactoryReverbPreset(.cathedral)
        environmentalNode.reverbBlend = 0.85
        environmentalNode.connect(mixer3D: source1mixer3D)
        environmentalNode.outputType = .externalSpeakers
        
        engine.mainMixerNode?.pan = 1.0
        
        print("------------------------------")
        print("-------CONNECTIONS-----------")
        print(source1mixer3D.connections)
        print("------------------------------")

        reverb = Reverb(player)
        reverb.loadFactoryPreset(.plate)
        reverb.dryWetMix = 1
        
        dryWetMixerReverb = DryWetMixer(environmentalNode, reverb)
        dryWetMixerReverb.balance = 0
        
        autoPanner = AutoPanner(player)
        autoPanner.frequency = 15
        dryWetMixerPanner = DryWetMixer(dryWetMixerReverb, autoPanner)
        dryWetMixerPanner.balance = 1
        
        totalMixer.addInput(dryWetMixerReverb)
        
        engine.output = totalMixer
        
        updatePlayerState()

        try? engine.start()
        
        loadAudioFiles()
    }
    
    deinit {
        player.stop()
        engine.stop()
    }
    
    func loadAudioFiles() {
        print("entered loadAudioFiles")
        for folder in audioFolders {
            do {
                guard let folderUrl = Bundle.main.url(forResource: folder, withExtension: "") else {continue}
                

                do {
                    let files = try fm.contentsOfDirectory(at: folderUrl, includingPropertiesForKeys: nil)
                    
                    for file in files {
                        if audioFiles[folder] == nil {
                            audioFiles[folder] = [AudioFile]()
                        }
                        audioFiles[folder]?.append(AudioFile(name: file.lastPathComponent, filePath: file.absoluteString, type: SoundType(rawValue:folder) ?? .ASMR))
                    }
                    
                } catch {
                    print("Ошибка при получении списка файлов: \(error.localizedDescription)")
                }

            }
        }
    }
    
    func playAudioFile(_ audioFile: AudioFile) {
        print("entered playAudioFile")
        
        guard let url = URL(string: audioFile.filePath) else { return }
        do {
            
            print("url: \(url)")
            try player.load(url: url)
            
            updatePlayerState()
            
            print("REVERB MIX=\(dryWetMixerReverb.balance)")
            
            print("REVERB TYPE=\(ProjectSettings.shared.currentSettings.reverbType)")
            
            player.play()
        } catch {
            print("Ошибка загрузки аудиофайла: \(error.localizedDescription)")
        }
    }
    
    func stopPlaying() {
        player.stop()
    }
    
    func setVolume(_ volume: AUValue) {
        player.volume = volume
    }
    
    func updatePlayerState() {
        environmentalNode.listenerPosition = AVAudio3DPoint(x: -ProjectSettings.shared.currentSettings.listenerX, y: ProjectSettings.shared.currentSettings.listenerY, z: ProjectSettings.shared.currentSettings.listenerZ)
        
        environmentalNode.listenerVectorOrientation = AVAudio3DVectorOrientation(forward: AVAudio3DVector(x: ProjectSettings.shared.currentSettings.vectorX, y: ProjectSettings.shared.currentSettings.vectorY, z: ProjectSettings.shared.currentSettings.vectorZ), up: AVAudio3DVector(x: 0, y: 0, z: 10))
        
        let reverbType = ProjectSettings.shared.currentSettings.reverbType
        if reverbType != -1 {
            reverb.loadFactoryPreset(reverbTypes[reverbType])
        }
        
        let reverbMix = ProjectSettings.shared.currentSettings.reverbMix
        dryWetMixerReverb.balance = reverbMix
        
    }
}
