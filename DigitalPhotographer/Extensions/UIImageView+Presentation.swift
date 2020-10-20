//
//  UIImageView+Presentation.swift
//  DigitalPhotographer
//
//  Created by Armando Brito on 10/20/20.
//  Copyright © 2020 arbridev. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func makeRoundCorners(radius: CGFloat = 20) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func makeCircle() {
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
}
