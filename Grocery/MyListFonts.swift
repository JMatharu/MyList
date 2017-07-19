//
//  MyListFonts.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-07-19.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import UIKit

private struct FontsName {
    static let spinnerFont = "Futura"
}

extension UIFont {
    class var spinnerFont: UIFont {
        return UIFont(name: FontsName.spinnerFont, size: 22.0)!
    }
}
