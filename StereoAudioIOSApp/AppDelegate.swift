//
//  AppDelegate.swift
//  StereoAudioIOSApp
//
//  Created by Владислав Сизикин.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let fm = FileManager.default
        let docsUrl = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        let asmrUrl = docsUrl.appendingPathComponent("ASMR")
        let natureUrl = docsUrl.appendingPathComponent("Nature")
        let musicUrl = docsUrl.appendingPathComponent("Music")
        let singleSoundsUrl = docsUrl.appendingPathComponent("SingleSounds")

        try? fm.createDirectory(at: asmrUrl, withIntermediateDirectories: true, attributes: nil)
        try? fm.createDirectory(at: natureUrl, withIntermediateDirectories: true, attributes: nil)
        try? fm.createDirectory(at: musicUrl, withIntermediateDirectories: true, attributes: nil)
        try? fm.createDirectory(at: singleSoundsUrl, withIntermediateDirectories: true, attributes: nil)

        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

