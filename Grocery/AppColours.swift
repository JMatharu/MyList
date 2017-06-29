//
//  Colors.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-06-23.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class AppColor {
    func navigationBarColor() -> UIColor {
        return UIColor(Constants.Color.NavigationBarColor)
    }
    
    func spinnerFont() -> UIFont {
        return UIFont(name: "Futura", size: 22.0)!
    }
}
