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
    
    var distanceTriggered = 10.0
    
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()

    var player: AVPlayer?
    
    var notCount: Int? = 0

    @IBOutlet weak var distLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
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
                options: .mixWithOthers)
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
        
//        player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 100), queue: DispatchQueue.main) { [weak self] time in
//            guard let self = self else { return }
//            let timeString = String(format: "%02.2f", CMTimeGetSeconds(time))
//            
//            if UIApplication.shared.applicationState == .active {
//                print("Active: \(timeString)")
//            } else {
//                print("Background: \(timeString)")
//            }
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    private func startTrackingDistance() {
        print("in tracking distance")
        pedometer.startUpdates(from: Date()) {
            [weak self] pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }
            print("in startUpdates")
            self?.distance = pedometerData.distance?.doubleValue
            
            print(pedometerData.distance ?? 0)
            self?.distLabel.text = self?.metersToMiles(distance: pedometerData.distance?.doubleValue) ?? "0"
            
            if (self?.distance)! > (self?.distanceTriggered)! {
                print("true")
                self?.notCount! += 1
                self?.sendNotification(distance: pedometerData.distance?.doubleValue, notifyCount: self?.notCount!)
                self?.distanceTriggered += 10.0
            }
            //                print("Steps: ")
            //                print(self?.steps)
            
        }
    }
    
//    private func doStuffBasedOnDistance(distance: Double?){
//        if distance! > 10.0 && distanceMessageTriggered == false {
//            distanceMessageTriggered = true
//            print("distance 20")
//            sendNotification(distance: distance)
//        }
//    }
    
    func metersToMiles(distance: Double?) -> String {
        guard let distance = distance else {
            return "0 miles"
        }
        let miles = distance * 0.0006213712
        let milesStr = String(format: "%.2f", miles)
        return milesStr + " miles"
    }
    
    func sendNotification(distance: Double?, notifyCount: Int?) {
        if let alertDistance = distance {

            //creates content of notification
            let content = UNMutableNotificationContent()
            content.title = "You have walked \(alertDistance) meters"
            content.body = "Expand notification to see more"
            content.categoryIdentifier = "infoCategory"
            content.sound = UNNotificationSound.default
            var pic = 0
            if notifyCount! <= 3 {
                pic = notifyCount!
            }else{
                pic = 1
            }
            let url = Bundle.main.url(forResource: "\(pic)", withExtension: "png")
            if let attachment = try? UNNotificationAttachment(identifier: "information", url: url!, options: nil){
                content.attachments = [attachment]
            }

            //tigger - what are the conditions for it to fire
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

            //create request
            let requestIdentifier = "information"
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if error != nil {
                    print("error \(String(describing:error))")
                }
            })
        }
    }
}
    


extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
