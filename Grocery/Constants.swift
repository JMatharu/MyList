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
        static let AllListViewControllerTableCellIdentifier = "AllListItem"
        static let StoreTagIdentifier = 50
        static let CategoryTagIdentifier = 51
        static let AmountTagIdentifier = 52
        static let NameTagIdentifier = 53
        static let AllListLabelTagIdentifier = 11
        static let AllListBadgeTagIdentifier = 12
        static let NameListTagIdentifier = 21
        static let TableViewRowActionEdit = "Edit"
        static let TableViewRowActionDelete = "Delete"
        static let MainStoryBoard = "Main"
        static let AddItemStoryBoard = "AddItemStoryBoard"
        static let AddItemSegue = "AddItem"
        static let ListItemStoryBoard = "ListViewController"
        static let AllListStoryBoard = "AllListViewController"
        static let GroceryListTabBarHomeView = "GroceryListTabBarHomeView"
        static let CategoryCell = "categoryCell"
        static let NameCell = "nameCell"
        static let NameVC = "NameViewController"
        static let CatVC = "CategoryViewController"
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
        static let Result = "Result"
        static let EnterNameAndCatagory = "Enter Name and Category"
    }
    
    struct Segue {
        static let AddItem = "AddItem"
        static let EditItem = "EditItem"
        static let LoginToList = "LoginToList"
        static let GroceryList = "GrocerySegue"
        static let CalculateGroceryList = "calculateItems"
        static let NewGroceryListIdentifier = "NewGroceryListIdentifier"
        static let NewToGroceryList = "NewToGroceryList"
    }
    
    struct Firebase {
        static let ParentGroceryRoot = "groceryList"
        static let ChildCategory = "category"
        static let ChildName = "name"
        static let ChildAmount = "amount"
        static let ChildStore = "store"
        static let ChildDate = "timestamp"
        static let ChildNameList = "nameList"
        static let ChildCategoryList = "categoryList"
    }
    
    struct XIB {
        static let GroceryTableHeader = "GroceryTableHeader"
    }
    
    struct Spinner {
        static let Title = "Please wait \nwhile we get your Lists..."
        static let TitleLogin = "Please wait..."
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
    
    struct Alert {
        static let IncompleteInformationTitle = "Incomplete Information!"
        static let IncompleteInformationDescription = "Make sure all the fields are filled before you proceed further"
        static let Ok = "Ok"
        static let Cancel = "Cancel"
        static let AddListAlertDescription = "Add List Item"
        static let AddListAlertTextViewPlaceHolder = "Enter Item"
        static let AddListAlertDeleteTitle = "Are you sure you want to delete this item?"
        static let AddListAlertDeleteDescription = "This action will delete item and its corresponding list."
        static let AddListAlertEditDescription = "Edit List Item"
    }
    
    struct Common {
        static let EmptyString = ""
    }
    
    struct Feature {
        static var Grocery = "Grocery"
        static var Shopping = "Shopping"
    }
    
    struct FABButton {
        static var AddItem = "Add"
        static var CalculateItem = "Calculate"
    }
}
