//
//  AddEditItemViewController.swift
//  Grocery
//
//  Created by Jagdeep Matharu on 2017-06-15.
//  Copyright © 2017 Jagdeep Matharu. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import FirebaseDatabase

protocol AddEditItemViewControllerDelegate: class {
    func addItemViewController(didFinishAdding item: GroceryItem)
    func addItemViewController(didFinishEditing item: GroceryItem)
    func addItemViewControllerDidCancel()
}

class AddEditItemViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var storeName: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    var pickerNameData = ["A", "B", "C"]
    var pickerCategoryData = ["one", "two", "three", "seven", "fifteen"]
    var namePicker = UIPickerView()
    var categoryPicker = UIPickerView()
    weak var delegate: AddEditItemViewControllerDelegate?
    var itemToEdit: GroceryItem?
    var firebaseReference: FIRDatabaseReference?
    var fireKey: String = ""
    
    override func viewDidLoad() {
        setNavigationBar()
        updateTableUI()
        storeName.becomeFirstResponder()
        setDelegateAndDataSourceForPicker()
        addPaddingOnUITextFields()
        setDataforEditScreen()
        
//        doneBarButton.isEnabled = false
        
//        storeName.addTarget(self, action: #selector(textFieldIsNotEmpty), for: .allEvents)
//        amount.addTarget(self, action: #selector(textFieldIsNotEmpty), for: .allEvents)
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
        firebaseReference = FIRDatabase.database().reference()
        if let item = itemToEdit {
            item.amount = amount.text!
            item.store = storeName.text!
            item.category = categoryTextField.text!
            item.name = nameTextField.text!
            delegate?.addItemViewController(didFinishEditing: item)
        } else {
            let item = GroceryItem()
            item.category = categoryTextField.text!
            item.amount = amount.text!
            item.name = nameTextField.text!
            item.store = storeName.text!
            
            //saving data to firebase
            let refForGroceryDataValue = firebaseReference?.child(Constants.Firebase.ParentGroceryRoot)
            let refChildByAutoId = refForGroceryDataValue?.childByAutoId()
            refChildByAutoId?.setValue([Constants.Firebase.ChildCategory : item.category, Constants.Firebase.ChildName : item.name, Constants.Firebase.ChildAmount : item.amount, Constants.Firebase.ChildStore : item.store, Constants.Firebase.ChildDate : self.getCurrentDateWithTime()])
//            var newItemKey: String = ""
//            if let key = refChildByAutoId?.key {
//                newItemKey = key
//            }
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
    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == namePicker {
            return pickerNameData.count
        } else {
            return pickerCategoryData.count
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == namePicker {
            nameTextField.text = pickerNameData[row]
        } else {
            categoryTextField.text = pickerCategoryData[row]
        }
        self.view.endEditing(false)
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == namePicker {
            return pickerNameData[row]
        } else {
            return pickerCategoryData[row]
        }
    }
    
    //MARK: - Textfield Delegate
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let oldText = textField.text! as NSString
//        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
//        
//        if newText.length > 0 {
//            doneBarButton.isEnabled = true
//        } else {
//            doneBarButton.isEnabled = false
//        }
//        return true
//    }
    
    //MARK: - Methods
    private func addPadding(textField: UITextField) {
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.UIDimentions.PaddingWidth, height: textField.frame.height))
        textField.leftViewMode = UITextFieldViewMode.always
    }
    
    private func setDelegateAndDataSourceForPicker() {
        namePicker.delegate = self
        namePicker.dataSource = self
        nameTextField.inputView = namePicker
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryTextField.inputView = categoryPicker
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
        if let item = itemToEdit {
            storeName.text = item.store
            amount.text = item.amount
            categoryTextField.text = item.category
            nameTextField.text = item.name
            doneBarButton.isEnabled = true
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
    
    func getCurrentDateWithTime() -> String {
        let date = Date()
        let calender = Calendar.current
        let hour = calender.component(.hour, from: date)
        let minute = calender.component(.minute, from: date)
        let sec = calender.component(.second, from: date)
        let dateInDigit = calender.component(.day, from: date)
        let month = calender.component(.month, from: date)
        let year = calender.component(.year, from: date)
        let weekday = calender.component(.weekday, from: date)
        var weekdayString: String
        switch weekday {
        case 1:
            weekdayString = "Sunday"
        case 2:
            weekdayString = "Monday"
        case 3:
            weekdayString = "Tuesday"
        case 4:
            weekdayString = "Wednesday"
        case 5:
            weekdayString = "Thursday"
        case 6:
            weekdayString = "Friday"
        case 7:
            weekdayString = "Saturday"
        default:
            weekdayString = "nil"
        }
        return "\(hour):\(minute):\(sec) on \(weekdayString) \(dateInDigit)/\(month)/\(year)"
    }
    
}
