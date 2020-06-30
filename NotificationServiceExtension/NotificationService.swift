//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by Robert Harrison on 6/30/20.
//  Copyright © 2020 RWH Technology, LLC. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        guard let bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent) else {
            return
        }
        
           
        if let attachmentURLString = bestAttemptContent.userInfo["url"] as? String,
            let attachmentURL = URL(string: attachmentURLString) {
            
            downloadImage(from: attachmentURL) { (attachment) in
                
                guard let attachment = attachment else {
                    contentHandler(bestAttemptContent)
                    return
                }
                
                bestAttemptContent.attachments = [attachment]
                contentHandler(bestAttemptContent)
                
            }
            
        } else {
            contentHandler(bestAttemptContent)
        }
            
        
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

    private func downloadImage(from url: URL, withCompletionHandler completionHandler: @escaping (UNNotificationAttachment?) -> Void) {
        URLSession.shared.downloadTask(with: url) { downloadURL, response, error in
            
            guard let downloadURL = downloadURL else {
                completionHandler(nil)
                return
            }
            
            var urlPath = URL(fileURLWithPath: NSTemporaryDirectory())
            let uniqueURLEnding = ProcessInfo.processInfo.globallyUniqueString + ".png"
            urlPath = urlPath.appendingPathComponent(uniqueURLEnding)
            
            try? FileManager.default.moveItem(at: downloadURL, to: urlPath)
            
            let attachment = try? UNNotificationAttachment(identifier: "image", url: urlPath, options: nil)
            completionHandler(attachment)
            
            
        }.resume()
    }
    
}
