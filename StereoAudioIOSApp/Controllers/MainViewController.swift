//
//  MainViewController.swift
//  StereoAudioIOSApp
//
//  Created by Владислав Сизикин.
//

import UIKit
import CoreMotion

class MainViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    var runtime = Runtime()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(changeListenerPosition(_:)), name: Notification.Name(rawValue: "updatePlayerState"), object: nil)
    }
    
    func getAudioFilePath(forResource name: String, ofType type: String) -> URL? {
        guard let asset = NSDataAsset(name: name) else {
            print("Не удалось найти ассет с именем: \(name)")
            return nil
        }
        
        let temporaryDirectoryURL = FileManager.default.temporaryDirectory
        let temporaryAudioFileURL = temporaryDirectoryURL.appendingPathComponent("\(name).\(type)")
        
        do {
            try asset.data.write(to: temporaryAudioFileURL)
        } catch {
            print("Не удалось записать аудиофайл во временное хранилище: \(error.localizedDescription)")
            return nil
        }
        
        return temporaryAudioFileURL
    }

    

    @IBAction func pressPlayButton(_ sender: UIButton) {
        print("entered pressPlayButton")
        
        let file = ProjectSettings.shared.currentSettings.selectedAudioFile
        print(file.name)
        
        if file.name != "" {
            runtime.playAudioFile(file)
        }
    }
    
    @IBAction func pressStopButton(_ sender: UIButton) {
        runtime.stopPlaying()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "changeSoundVC":
            if let vc = segue.destination as? SelectSoundViewController {
                vc.sounds = runtime.player.AudioFiles
                print("vc.sounds.count = \(vc.sounds.count)")
            }
        default:
            break
        }
    }
    
    @objc func changeListenerPosition(_ notification: Notification) {
        runtime.player.updatePlayerState()
    }

}
