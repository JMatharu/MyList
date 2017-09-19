//
//  AddEditItemViewController.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-06-15.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import PMAlertController
import CZPicker

struct AddItemVCConstants {
    static let DateFormat = "yyyyMMddHHmmss"
}

protocol AddEditItemViewControllerDelegate: class {
    func addItemViewController(didFinishAdding item: GroceryItem)
    func addItemViewController(didFinishEditing item: GroceryItem)
    func addItemViewControllerDidCancel()
}

class AddEditItemViewController: UITableViewController, CZPickerViewDelegate, CZPickerViewDataSource {
    @IBOutlet weak var storeName: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    var pickerNameData:[String] = []
    var pickerCategoryData:[String] = []
    var namePicker = CZPickerView()
    var categoryPicker = CZPickerView()
    weak var delegate: AddEditItemViewControllerDelegate?
    var itemToEdit: GroceryItem?
    var parentNode: String = ""
    var tempItemToEdit: [String:GroceryItem?] = [:]
    var fireKey: String = ""
    var editKey: String = ""
    
    override func viewDidLoad() {
        setNavigationBar()
        updateTableUI()
        storeName.becomeFirstResponder()
        loadNameAndCategory()
        addPaddingOnUITextFields()
        setDataforEditScreen()
        nameTextField.isUserInteractionEnabled = false
        categoryTextField.isUserInteractionEnabled = false
    }
 
    // MARK: - IBAction
    func cancel() {
        delegate?.addItemViewControllerDidCancel()
        // If using "Modal" then dismiss
        dismiss(animated: true, completion: nil)
        // If using "show" then popviewcontroller
        // self.navigationController?.popViewController(animated: true)
    }
    
    func done() {
        guard
            let store = storeName.text,
            !store.isEmpty,
            let amo = amount.text,
            !amo.isEmpty,
            let cat = categoryTextField.text,
            !cat.isEmpty,
            let name = nameTextField.text,
            !name.isEmpty
            else {
            let alertVC = PMAlertController(withTitle: Constants.Alert.IncompleteInformationTitle, withDescription: Constants.Alert.IncompleteInformationDescription)
            alertVC.addAction(PMAlertAction(title: Constants.Alert.Ok, style: PMAlertActionStyle.default, action: {
                alertVC.dismiss(animated: true, completion: nil)
            }))
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        
        if let item = itemToEdit {
            item.amount = amount.text!
            item.store = storeName.text!
            item.category = categoryTextField.text!
            item.name = nameTextField.text!
            let dataToBeSavedAfterEdit = [Constants.Firebase.ChildCategory : item.category, Constants.Firebase.ChildName : item.name, Constants.Firebase.ChildAmount : item.amount, Constants.Firebase.ChildStore : item.store, Constants.Firebase.ChildDate : self.getCurrentDateWithTime()]
            FirebaseService().saveEditedGroceryList(key: editKey, parentNode: parentNode, dictionaryOfData: dataToBeSavedAfterEdit)
            delegate?.addItemViewController(didFinishEditing: item)
        } else {
            let item = GroceryItem()
            item.category = categoryTextField.text!
            item.amount = amount.text!
            item.name = nameTextField.text!
            item.store = storeName.text!
            
            //saving data to firebase
            let dataToBeSaved = [Constants.Firebase.ChildCategory : item.category, Constants.Firebase.ChildName : item.name, Constants.Firebase.ChildAmount : item.amount, Constants.Firebase.ChildStore : item.store, Constants.Firebase.ChildDate : self.getCurrentDateWithTime()]
            FirebaseService().saveGroceryList(parentNode:parentNode, dictionaryOfData: dataToBeSaved)
            delegate?.addItemViewController(didFinishAdding: item)
        }
        // If using "Modal" then dismiss
        dismiss(animated: true, completion: nil)
        // If using "show" then popviewcontroller
        // self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    //MARK: - Picker Methods
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        if pickerView == namePicker {
            return pickerNameData.count
        } else {
            return pickerCategoryData.count
        }
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        if pickerView == namePicker {
            return pickerNameData[row]
        } else {
            return pickerCategoryData[row]
        }
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        if pickerView == namePicker {
            nameTextField.text = pickerNameData[row]
        } else {
            categoryTextField.text = pickerCategoryData[row]
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Methods
    private func addPadding(textField: UITextField) {
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.UIDimentions.PaddingWidth, height: textField.frame.height))
        textField.leftViewMode = UITextFieldViewMode.always
    }
    
    private func addPaddingOnUITextFields() {
        addPadding(textField: storeName)
        addPadding(textField: amount)
        addPadding(textField: categoryTextField)
        addPadding(textField: nameTextField)
    }
    
    func textFieldIsNotEmpty(sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        guard (storeName.text?.isEmpty)!, (amount.text?.isEmpty)! else {
            doneBarButton.isEnabled = false
            return
        }
        doneBarButton.isEnabled = true
    }
    
    private func setDataforEditScreen() {
        for (key, value) in tempItemToEdit {
            if let item = value {
                title = "Edit Item"
                storeName.text = item.store
                amount.text = item.amount
                categoryTextField.text = item.category
                nameTextField.text = item.name
                doneBarButton.isEnabled = true
            }
            editKey = key
        }
    }
    
    private func setNavigationBar() {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(Constants.UIDimentions.NavigationBarHeight)))
        self.view.addSubview(navigationBar)
        let navItem: UINavigationItem
        if itemToEdit != nil {
            navItem = UINavigationItem(title: Constants.Titles.EditItem)
        } else {
            navItem = UINavigationItem(title: Constants.Titles.AddItem)
        }
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(AddEditItemViewController.done))
        navItem.rightBarButtonItem = doneBarButton
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: nil, action: #selector(AddEditItemViewController.cancel))
        navItem.leftBarButtonItem = cancelBarButton
        navigationBar.setItems([navItem], animated: true)
        navigationBar.barTintColor = UIColor.navigationBarColor
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationBar.tintColor = UIColor.white
    }
    
    func updateTableUI() {
        tableView.tableHeaderView = UIView(frame: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(tableView.bounds.size.width), height: Constants.UIDimentions.NavigationBarHeight))
    }
    
    @IBAction func selectPatient(_ sender: Any) {
        self.view.endEditing(true) // Disabling Keyboard
        namePicker = CZPickerView(headerTitle: "Names", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        namePicker.delegate = self
        namePicker.dataSource = self
        namePicker.needFooterView = true
        namePicker.show()
    }
    @IBAction func selectCategory(_ sender: Any) {
        self.view.endEditing(true) // Disabling Keyboard
        categoryPicker = CZPickerView(headerTitle: "Categories", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryPicker.needFooterView = true
        categoryPicker.show()
    }
    
    func getCurrentDateWithTime() -> String {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AddItemVCConstants.DateFormat
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        return dateFormatter.string(from: date as Date)
    }
    
    func loadNameAndCategory() {
        NameCategorySharedService.sharedInstance.initializeNamesArray { (nameList) in
            for name in nameList {
                self.pickerNameData.append(name)
            }
            self.pickerNameData.sort(by: <)
        }
        
        NameCategorySharedService.sharedInstance.initializeCategoryArray { (categoryList) in
            for category in categoryList {
                self.pickerCategoryData.append(category)
            }
            self.pickerCategoryData.sort(by: <)
        }
    }
}
