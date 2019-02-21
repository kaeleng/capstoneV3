//
//  ViewController.swift
//  capstoneV3
//
//  Created by Kaelen Guthrie on 2/19/19.
//  Copyright © 2019 Kaelen Guthrie. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var distance : Double! = nil
    var steps : NSNumber! = nil
    var stepMessageTriggered = false
    var distanceMessageTriggered = false
    
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        if distance! > 1.0 && distanceMessageTriggered == false {
            distanceMessageTriggered = true
            print("distance 1")
        }
    }


}

