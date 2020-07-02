//
//  UIImageView+Remote.swift
//  FCMSample
//
//  Created by Robert Harrison on 7/2/20.
//  Copyright © 2020 RWH Technology, LLC. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadRemote(url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url) else { return }
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
