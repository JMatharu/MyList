//
//  MyFabButton.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-07-29.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//
import UIKit
import KCFloatingActionButton

extension KCFloatingActionButton {
    convenience init(itemTitle:String, itemImage:UIImage, view:UIView, completionHandler:[() -> Void]) {
        
        let floaty = KCFloatingActionButton()
        floaty.sticky = true
        floaty.openAnimationType = .slideLeft
        floaty.buttonColor = UIColor.FabButtonColor
        floaty.itemButtonColor = UIColor.FabButtonSecendoryColor
        floaty.itemTitleColor = UIColor.FabButtonItemTitleColor
        floaty.itemShadowColor = UIColor.blue
        floaty.addItem(itemTitle, icon: itemImage) { (fabButtonItem) in
            print(completionHandler)
        }
        floaty.buttonImage = #imageLiteral(resourceName: "addItem")
        self.init()
    }
    
    func createFabButton() -> KCFloatingActionButton {
        let floaty = KCFloatingActionButton()
        floaty.sticky = true
        floaty.openAnimationType = .slideLeft
        floaty.buttonColor = UIColor.FabButtonColor
        floaty.itemButtonColor = UIColor.FabButtonSecendoryColor
        floaty.itemTitleColor = UIColor.FabButtonItemTitleColor
        floaty.itemShadowColor = UIColor.blue
        floaty.buttonImage = #imageLiteral(resourceName: "addItem")
        floaty.customShift = 50
        return floaty
    }
}
