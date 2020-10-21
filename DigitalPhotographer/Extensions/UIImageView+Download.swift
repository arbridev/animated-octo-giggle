//
//  UIImageView+Download.swift
//  DigitalPhotographer
//
//  Created by Armando Brito on 10/19/20.
//  Copyright © 2020 arbridev. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func downloadImageFrom(link: String, contentMode: UIView.ContentMode) {
        if let url = URL(string:link) {
            URLSession.shared.dataTask( with: url, completionHandler: {
                (data, response, error) -> Void in
                DispatchQueue.main.async {
                    self.contentMode =  contentMode
                    if let data = data { self.image = UIImage(data: data) }
                }
            }).resume()
        }
    }
    
}
