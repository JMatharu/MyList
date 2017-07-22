//
//  MyListAlert.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-07-20.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import Foundation
import PMAlertController

extension PMAlertController {
    
    convenience init(withTitle title: String, withDescription description:String, withImage image:String) {
       self.init(title: title, description: description, image: UIImage(named: image), style: .alert)
    }
    
    convenience init(withTitle title: String, withDescription description:String) {
        self.init(title: title, description: description, image: nil, style: .alert)
    }

}
