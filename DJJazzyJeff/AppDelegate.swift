//
//  AppDelegate.swift
//  DJ Jazzy Jaff
//
//  Created by Jigar Khatri on 22/11/22.
//

import UIKit
import RHPlaceholder
import AVFAudio
import AVKit
import MediaPlayer

//LOADER
public let placeholderMarker = Placeholder()

//GLOBAL VARIABLE
public var isMusicViewOpen : Bool = false


//MUSIC PLAYER
var musicView = MusicTabView()
var isMusicPlay : Bool = false

//PLAYER
var playerVideo: AVPlayer?
var playerItem: AVPlayerItem!
var playerTimer: Timer?


@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //SET KEYBORD
        setupKeyboard(true)

        return true
    }

    
    /// set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
   

}

