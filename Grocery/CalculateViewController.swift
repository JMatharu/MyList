//
//  CalculateViewController.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-07-28.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import UIKit

class CalculateViewController: UIViewController {
    override func viewDidLoad() {
        //Setup Nav Bar
        
    }
    
    override func viewWillLayoutSubviews() {
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(Constants.UIDimentions.NavigationBarHeight)))
        self.view.addSubview(navigationBar)
        let navItem: UINavigationItem
        navItem = UINavigationItem(title: Constants.Titles.Result)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(AddEditItemViewController.done))
        navItem.rightBarButtonItem = doneBarButton
        navigationBar.setItems([navItem], animated: true)
        navigationBar.barTintColor = UIColor.navigationBarColor
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationBar.tintColor = UIColor.white
    }
    
    func done() {
        dismiss(animated: true, completion: nil)
    }
}