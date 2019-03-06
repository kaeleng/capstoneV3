//
//  ViewController.swift
//  capstoneV3
//
//  Created by Kaelen Guthrie on 2/19/19.
//  Copyright © 2019 Kaelen Guthrie. All rights reserved.
//

import UIKit
import CoreMotion
import UserNotifications
import AVFoundation

class ViewController: UIViewController {
    
    var distance : Double! = nil
    var steps : NSNumber! = nil
    var stepMessageTriggered = false
    var distanceMessageTriggered = false
    
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()

    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
            (granted, error) in
            if granted {
                print("yes")
            }
            else {
                print("no")
            }
        }
        
        let status = CMPedometer.authorizationStatus()
        startTrackingDistance()
//                if status == .authorized{
//                                print("authorized")
//                    startTrackingDistance()
//                }
//
//                if status == .denied || status == .notDetermined{
//                                print("denied")
//                    let alert = UIAlertController(title: "This app requires location access", message: "Please turn allow location access for this application", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Okay.", style: .default) { _ in })
//                    self.present(alert, animated: true){}
//                }
        do {
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSession.Category.playback,
                mode: .default,
                options: [])
        } catch {
            print("Failed to set audio session category.  Error: \(error)")
        }
        
        var item: AVPlayerItem? = nil
        if let url = Bundle.main.url(forResource: "silence", withExtension: "mp3") {
            item = AVPlayerItem(url: url)
        }
        self.player = AVPlayer(playerItem: item)
        
        player?.actionAtItemEnd = .none
        player?.play()
        
        player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 100), queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else { return }
            let timeString = String(format: "%02.2f", CMTimeGetSeconds(time))
            
            if UIApplication.shared.applicationState == .active {
                print("Active: \(timeString)")
            } else {
                print("Background: \(timeString)")
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    private func startTrackingDistance() {
        print("in tracking distance")
        pedometer.startUpdates(from: Date()) {
            [weak self] pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }
            print("in startUpdates")
            DispatchQueue.main.async{
                print("check")
                //                self?.distance = pedometerData.distance?.doubleValue
                //                self?.steps = pedometerData.numberOfSteps
                self?.doStuffBasedOnDistance(distance: pedometerData.distance?.doubleValue)
                //                self?.doStuffBasedOnSteps(steps: self?.steps)
                print(pedometerData.distance ?? 0)
                //                print("Steps: ")
                //                print(self?.steps)
            }
        }
    }
    
    private func doStuffBasedOnDistance(distance: Double?){
        if distance! > 10.0 && distanceMessageTriggered == false {
            distanceMessageTriggered = true
            print("distance 20")
            sendNotification(distance: distance)
        }
    }
    
    func sendNotification(distance: Double?) {
        
        if let alertDistance = distance {
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = "You have walked \(alertDistance) meters"
            content.body = "Open the app to learn more"
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            
            let request = UNNotificationRequest(identifier: "Content Identifier", content: content, trigger: trigger)
            
            center.add(request) { (error) in
                if error != nil {
                    print("error \(String(describing: error))")
                }
                
            }
        }
        
    } 


}

