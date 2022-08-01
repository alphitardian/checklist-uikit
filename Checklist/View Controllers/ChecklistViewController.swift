//
//  ViewController.swift
//  Checklist
//
//  Created by Ardian Pramudya Alphita on 09/07/22.
//

import UIKit

class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {
    
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }
    
    // MARK: - Table View Data Source
    
    // This function indicates the number of row in section
    // Usually it filled with the number of data available
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return checklist.items.count
    }
    
    // This function used for setup the reusable cell in tableview
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
        }
        
        // Used for disabling grey box when row selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // This method automatically enabled swipe-to-delete
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        checklist.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // MARK: - Add View Controller Delegate
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(
        _ controller: AddItemViewController,
        didFinishAdding item: ChecklistItem
    ) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        // Create index path to identify row
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        // Temporary array to save index path
        let indexPaths = [indexPath]
        // Insert to table view and update
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(
        _ controller: AddItemViewController,
        didFinishEditing item: ChecklistItem
    ) {
        // Get index from the available item
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            if let destination = segue.destination as? AddItemViewController {
                destination.delegate = self
            }
        } else if segue.identifier == "EditItem" {
            if let destination = segue.destination as? AddItemViewController {
                destination.delegate = self
                
                // Get selected row from table view
                if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                    destination.itemToEdit = checklist.items[indexPath.row]
                }
            }
        }
    }
}

