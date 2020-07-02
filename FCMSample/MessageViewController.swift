//
//  MessageViewController.swift
//  FCMSample
//
//  Created by Robert Harrison on 6/30/20.
//  Copyright © 2020 RWH Technology, LLC. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var bodyLabel: UILabel!
    
    private var message: FCMMessage!
    private var imageURL: String?
    
    // MARK: - Configuration
    
    static func configured(message: FCMMessage, imageURL: String?) -> MessageViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "MessageViewController"
        ) as! MessageViewController
        viewController.message = message
        viewController.imageURL = imageURL
        return viewController
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = message.title
        bodyLabel.text = message.body
        
        if let imageURLString = imageURL, let url = URL(string: imageURLString) {
            imageView.loadRemote(url: url)
        } else {
            stackView.removeArrangedSubview(imageView)
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func closePressed() {
        dismiss(animated: true, completion: nil)
    }
    

}
