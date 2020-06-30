//
//  ViewController.swift
//  FCMSample
//
//  Created by Robert Harrison on 6/30/20.
//  Copyright © 2020 RWH Technology, LLC. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction private func subscribePressed() {
        Messaging.messaging().subscribe(toTopic: "weather") { error in
            print("Subscribed to weather topic")
        }

    }
    
    @IBAction private func unsubscribePressed() {
        Messaging.messaging().unsubscribe(fromTopic: "weather")
        print("Unsubscribed from weather topic")
    }

}

