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
}

extension UIColor {
    class var navigationBarColor: UIColor {
        return UIColor(Color.NavigationBarColor)
    }
}
