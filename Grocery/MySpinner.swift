//
//  MySpinner.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-07-25.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import SwiftSpinner

extension SwiftSpinner {
    convenience init(title:String, subTitle: String) {
        SwiftSpinner.setTitleFont(UIFont.spinnerFont)
        SwiftSpinner.show(title, animated: true).addTapHandler({
            SwiftSpinner.hide()
        }, subtitle: subTitle)
        self.init()
    }
    
    convenience init(title: String) {
        SwiftSpinner.setTitleFont(UIFont.spinnerFont)
        SwiftSpinner.show(title, animated: true).addTapHandler({
            SwiftSpinner.hide()
        })
        self.init()
    }
}
