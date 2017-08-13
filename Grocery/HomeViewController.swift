//
//  HomeViewController.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-08-13.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        setTabs()
    }   
    
    private func setTabs() {
        tabBar.items?[0].title = "Dashboard"
        tabBar.items?[1].title = "My Lists"
    }
}
