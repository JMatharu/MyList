//
//  Constants.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-06-14.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct Identifiers {
        static let ListViewControllerTableCellIdentifier = "ListItem"
        static let StoreIdentifier = 50
        static let CategoryIdentifier = 51
        static let AmountIdentifier = 52
        static let NameIdentifier = 53
        static let TableViewRowActionEdit = "Edit"
        static let TableViewRowActionDelete = "Delete"
        static let MainStoryBoard = "Main"
        static let AddItemStoryBoard = "AddItemStoryBoard"
        static let AddItemSegue = "AddItem"
    }
    
    struct UIDimentions {
        static let PaddingWidth: CGFloat = 5
        static let EstimatedRowHeightForTableCell: CGFloat = 40
        static let NavigationBarHeight: CGFloat = 60
    }
    
    struct Titles {
        static let AddItem = "Add Item"
        static let EditItem = "Edit Item"
        static let NoItem = "No Items in List"
        static let Items = " Items"
    }
    
    struct Segue {
        static let AddItem = "AddItem"
    }
    
    struct Color {
        static let NavigationBarColor = "#7A61BD"
    }
    
    struct Firebase {
        static let ParentGroceryRoot = "groceryList"
        static let ChildCategory = "category"
        static let ChildName = "name"
        static let ChildAmount = "amount"
        static let ChildStore = "store"
        static let ParentGroceryKeyRoot = "groceryKeysList"
    }
}
