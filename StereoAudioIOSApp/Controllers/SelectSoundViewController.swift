//
//  SelectSoundViewController.swift
//  StereoAudioIOSApp
//
//  Created by Владислав Сизикин.
//

import UIKit

class SelectSoundViewController: UIViewController {
    
    var sounds:[String:[AudioFile]] = [:]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView?.delegate = self
        tableView.reloadData()
    }

}

extension SelectSoundViewController:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        print("sound.count = \(sounds.count)")
        return sounds.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keys = Array(sounds.keys)
        return sounds[keys[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "soundCell", for: indexPath)
        let soundTypes = Array(sounds.keys)
        let soundNames = sounds[soundTypes[indexPath.section]]
        cell.textLabel?.text = soundNames?[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let keys = Array(sounds.keys)
        return keys[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let soundTypes = Array(sounds.keys)
        ProjectSettings.shared.currentSettings.selectedAudioFile = sounds[soundTypes[indexPath.section]]![indexPath.row]
        print("we changed on \(sounds[soundTypes[indexPath.section]]![indexPath.row].name)")
        print("on settings now: \(ProjectSettings.shared.currentSettings.selectedAudioFile.name)")
    }
    
    
}
