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
        static let ListItemStoryBoard = "ListViewController"
    }
    
    struct UIDimentions {
        static let PaddingWidth: CGFloat = 5
        static let EstimatedRowHeightForTableCell: CGFloat = 40
        static let NavigationBarHeight: CGFloat = 60
        static let ButtonHeight: CGFloat = 40
        static let ButtonLeftPadding: CGFloat = 20
        static let ButtonRightPadding: CGFloat = -20
        static let ButtonTopPadding: CGFloat = 70
    }
    
    struct Titles {
        static let AddItem = "Add Item"
        static let EditItem = "Edit Item"
        static let NoItem = "No Items in List"
        static let Items = " Items"
        static let FacebookButton = "Sign in with Facebook"
    }
    
    struct Segue {
        static let AddItem = "AddItem"
        static let LoginToList = "LoginToList"
    }
    
    struct Firebase {
        static let ParentGroceryRoot = "groceryList"
        static let ChildCategory = "category"
        static let ChildName = "name"
        static let ChildAmount = "amount"
        static let ChildStore = "store"
        static let ChildDate = "timestamp"
    }
    
    struct XIB {
        static let GroceryTableHeader = "GroceryTableHeader"
    }
    
    struct Spinner {
        static let Title = "Please wait \nwhile we get your Lists..."
        static let TitleAfterUpdate = "Please wait \nwhile we update your Lists..."
        static let SubTitle = "Tap to hide while connecting! This will affect only the current operation."
    }
    
    struct UserPermissions {
        static let PublicProfile = "public_profile"
        static let Email = "email"
    }
    
    struct UserDefaults {
        static let IsUserLoggedIn = "IsUserLoggedIn"
        static let UID = "uid"
    }
}
