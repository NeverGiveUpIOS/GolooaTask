//
//  UIImageViewExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/27.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func imageWithString(_ imgName: String) {
        self.image = UIImage(named: imgName)
    }
}

// MARK: - Set Url Image
extension UIImageView {
    func headerImageUrl(_ urlStr: String, placeholder: UIImage? = nil) {
        imageWithUrl(withURL: urlStr, placeholder: placeholder ?? .publicDefault)
    }
    
    func normalImageUrl(_ urlStr: String, placeholder: UIImage? = nil) {
        imageWithUrl(withURL: urlStr, placeholder: placeholder ?? .publicPlaceholder)
    }

    func imageWithUrl(
        withURL imageURL: String,
        placeholder: UIImage? = nil) {
            
        guard
            imageURL.starts(with: "http"),
            let imageURL = URL(string: imageURL)
        else {
            if let placeholder = placeholder {
                image = placeholder
            } else {
                image = UIImage.init(named: imageURL)
            }
            return
        }
        
        kf.indicatorType = .activity
        kf.setImage(with: imageURL, placeholder: placeholder)
    }
}
