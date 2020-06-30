//
//  MessageViewController.swift
//  FCMSample
//
//  Created by Robert Harrison on 6/30/20.
//  Copyright © 2020 RWH Technology, LLC. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var bodyLabel: UILabel!
    
    private var message: FCMMessage!
    
    // MARK: - Configuration
    
    static func configured(message: FCMMessage) -> MessageViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "MessageViewController"
        ) as! MessageViewController
        viewController.message = message
        return viewController
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = message.title
        bodyLabel.text = message.body
    }
    
    // MARK: - Actions
    
    @IBAction private func closePressed() {
        dismiss(animated: true, completion: nil)
    }
    

}
