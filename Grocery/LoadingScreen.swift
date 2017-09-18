//
//  LoadingScreen.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-09-18.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import UIKit
import SwiftSpinner

class LoadingScreen: UIViewController {
    override func viewDidLoad() {
        _ = SwiftSpinner.init(title: "Loading ...\nPlease Wait ...", subTitle: "Make sure you are in network!")
        UIApplication.shared.beginIgnoringInteractionEvents()
        FirebaseService().isNameOrCategoryExist(completion: { (status) in
            if status == true {
                self.performSegue(withIdentifier: "LoginToList", sender: nil)
            } else {
                self.performSegue(withIdentifier: "NewGroceryListIdentifier", sender: true)
            }
            UIApplication.shared.endIgnoringInteractionEvents()
            SwiftSpinner.hide()
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewGroceryListIdentifier" {
            let controller = segue.destination as! NameCategoryListViewController
            controller.isBackButtonDisabled = sender as! Bool
        }
    }
}
