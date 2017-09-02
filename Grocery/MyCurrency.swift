//
//  MyCurrency.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-09-02.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import Foundation

class CurrencyFormatter {
    func getLocalCurrency(amount: NSNumber) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = NSLocale.current
        return String(describing: formatter.string(from: amount)!)
    }
}
