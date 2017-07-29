//
//  MyBadge.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-07-23.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import Foundation
import EasyNotificationBadge

extension BadgeAppearnce {
    init(badgeView view: UIView, badgeText text: String, badgeColor color:UIColor) {
        var appearnce = BadgeAppearnce()
        appearnce.backgroundColor = color
        appearnce.textColor = UIColor.white
        appearnce.textAlignment = .center
        appearnce.textSize = 15
        appearnce.distenceFromCenterX = view.frame.width * 0.01
        appearnce.distenceFromCenterY = view.frame.height * 0.01
        appearnce.allowShadow = true
        appearnce.borderColor = color
        appearnce.borderWidth = 1
        view.badge(text: text, appearnce: appearnce)
        self.init()
    }
}
