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

    override func didReceive(_ request: UNNotificationRequest,
                             withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        self.contentHandler = contentHandler
        guard let bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent) else {
            return
        }
        
        // Convert userInfo to data, so we can use the JSONDecoder on it.
        guard let data = try? JSONSerialization.data(withJSONObject: bestAttemptContent.userInfo, options: .prettyPrinted) else {
            return
        }
        
        // Get the payload from the data.
        guard let payload = try? JSONDecoder().decode(FCMPayload.self, from: data) else {
            return
        }
        
        if let imageURLString = payload.options?.image, let imageURL = URL(string: imageURLString) {
            
            // Download the image and add it to the notification's attachments.
            // This is required to get the image to appear in the notification.
            downloadImage(from: imageURL) { (attachment) in
                
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
            let uniqueURLEnding = ProcessInfo.processInfo.globallyUniqueString + ".jpg"
            urlPath = urlPath.appendingPathComponent(uniqueURLEnding)
            
            try? FileManager.default.moveItem(at: downloadURL, to: urlPath)
            
            let attachment = try? UNNotificationAttachment(identifier: "image", url: urlPath, options: nil)
            completionHandler(attachment)
            
            
        }.resume()
    }
    
}
