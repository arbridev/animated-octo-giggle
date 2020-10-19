//
//  LauncherVC.swift
//  DigitalPhotographer
//
//  Created by Armando Brito on 10/18/20.
//  Copyright © 2020 arbridev. All rights reserved.
//

import UIKit

class LauncherVC: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performSegue(withIdentifier: "MainTabBar", sender: self)
    }

}
