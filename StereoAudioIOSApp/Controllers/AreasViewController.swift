//
//  AreasViewController.swift
//  StereoAudioIOSApp
//
//  Created by Владислав Сизикин.
//

import UIKit

class AreasViewController: UIViewController {

    @IBOutlet var positionSliders: [UISlider]!
    
    @IBOutlet var vectorSliders: [UISlider]!
    
    @IBOutlet var reverbTypeButtons: [UIButton]!
    
    @IBOutlet weak var dryWetReverbSlider: UISlider!
    
    @IBAction func pressPositionRandomButton(_ sender: UIButton) {
        for slider in positionSliders {
            slider.value = Float.random(in: slider.minimumValue..<slider.maximumValue)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updatePlayerState"), object: nil)
    }
    
    @IBAction func pressVectorRandomButton(_ sender: UIButton) {
        for slider in vectorSliders {
            slider.value = Float.random(in: slider.minimumValue..<slider.maximumValue)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updatePlayerState"), object: nil)
    }
    
    @IBAction func moveReverbSlider(_ sender: UISlider) {
        ProjectSettings.shared.currentSettings.reverbMix = sender.value
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updatePlayerState"), object: nil)
    }
    
    @IBAction func pressReverbButton(_ sender: UIButton) {
        ProjectSettings.shared.currentSettings.reverbType = sender.tag
        
        for button in reverbTypeButtons {
            button.isHighlighted = false
        }
        
        sender.isHighlighted = true
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updatePlayerState"), object: nil)
    }
    
    @IBAction func moveSlider(_ sender: UISlider) {
        
        for slider in positionSliders {
            switch slider.tag {
            case 0:
                ProjectSettings.shared.currentSettings.listenerX = slider.value
            case 1:
                ProjectSettings.shared.currentSettings.listenerY = slider.value
            case 2:
                ProjectSettings.shared.currentSettings.listenerZ = slider.value
            default:
                continue
            }
        }
        
        for slider in vectorSliders {
            switch slider.tag {
            case 0:
                ProjectSettings.shared.currentSettings.vectorX = slider.value
            case 1:
                ProjectSettings.shared.currentSettings.vectorY = slider.value
            case 2:
                ProjectSettings.shared.currentSettings.vectorZ = slider.value
            default:
                continue
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updatePlayerState"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for slider in positionSliders {
            switch slider.tag {
            case 0:
                slider.value = ProjectSettings.shared.currentSettings.listenerX
            case 1:
                slider.value = ProjectSettings.shared.currentSettings.listenerY
            case 2:
                slider.value = ProjectSettings.shared.currentSettings.listenerZ
            default:
                continue
            }
        }
        
        for slider in vectorSliders {
            switch slider.tag {
            case 0:
                slider.value = ProjectSettings.shared.currentSettings.vectorX
            case 1:
                slider.value = ProjectSettings.shared.currentSettings.vectorY
            case 2:
                slider.value = ProjectSettings.shared.currentSettings.vectorZ
            default:
                continue
            }
        }
        
        dryWetReverbSlider.value = ProjectSettings.shared.currentSettings.reverbMix
    }

}
