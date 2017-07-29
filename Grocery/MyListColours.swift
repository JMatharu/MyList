//
//  MyListColours.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-06-23.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import UIColor_Hex_Swift

private struct Color {
    static let NavigationBarColor = "#512DA8"
    static let FabButtonColor = "#9C27B0"
    static let FabBottonSecColor = "#9C27B0"
    static let FabButtonItemTitleColor = "#303F9F"
}

extension UIColor {
    class var navigationBarColor: UIColor {
        return UIColor(Color.NavigationBarColor)
    }
    
    class var FabButtonColor: UIColor {
        return UIColor(Color.FabButtonColor)
    }
    
    class var FabButtonSecendoryColor: UIColor {
        return UIColor(Color.FabBottonSecColor)
    }
    
    class var FabButtonItemTitleColor: UIColor {
        return UIColor(Color.FabButtonItemTitleColor)
    }
}
