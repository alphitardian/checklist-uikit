//
//  AddItemViewController.swift
//  Checklist
//
//  Created by Ardian Pramudya Alphita on 11/07/22.
//

import UIKit
import UserNotifications

// Create delegate protocol for add item
protocol AddItemViewControllerDelegate: AnyObject {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem)
    func addItemViewController(_ controller: AddItemViewController, didFinishEditing item: ChecklistItem)
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var itemToEdit: ChecklistItem?
    
    // Declare property to use the delegate
    weak var delegate: AddItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Give text field focus when the screen loaded
        textField.becomeFirstResponder()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            datePicker.date = item.dueDate
        }
    }
    
    // MARK: Table View Delegate
    override func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        return nil
    }
    
    // MARK: Text Field Delegate
    
    // This method used for detecting text changes
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
                
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
    
    // This method used when clear button tapped
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }

    // MARK: - Actions
    @IBAction func closeAddItem() {
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func doneAddItem() {
        if let item = itemToEdit {
            item.text = textField.text ?? ""
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.addItemViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text ?? ""
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.addItemViewController(self, didFinishAdding: item)
        }
    }
    
    @IBAction func shouldRemindToggled(_ sender: UISwitch) {
        textField.resignFirstResponder()
        
        if sender.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                
            }
        }
    }
}
