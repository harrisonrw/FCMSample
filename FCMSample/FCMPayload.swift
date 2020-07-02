//
//  FCMPayload.swift
//  FCMSample
//
//  Created by Robert Harrison on 6/30/20.
//  Copyright © 2020 RWH Technology, LLC. All rights reserved.
//

import Foundation

struct FCMPayload: Codable {
    var messageId: String
    var options: FCMOptions?
    var aps: FCMAPS
    
    private enum CodingKeys: String, CodingKey {
        case messageId = "gcm.message_id"
        case options = "fcm_options"
        case aps
    }
}

struct FCMOptions: Codable {
    var image: String
}

struct FCMAPS: Codable {
    var message: FCMMessage
    var sound: String
    
    private enum CodingKeys: String, CodingKey {
        case message = "alert"
        case sound
    }
}

struct FCMMessage: Codable {
    var title: String
    var body: String
}
