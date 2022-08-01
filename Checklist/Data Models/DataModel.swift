//
//  DataModel.swift
//  Checklist
//
//  Created by Ardian Pramudya Alphita on 26/07/22.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    // Computed property example
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    init() {
        loadChecklists()
        registerDefault()
        handleFirstTime()
    }
    
    // Method to get document directory url
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    // Method to construct full path to the file that will save the data "Checklists.plist"
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }

    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            // encode data to binary
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }

    func loadChecklists() {
        let path = dataFilePath()
        // Load content from checklist.plist
        // If fail, the result is nil. That's why we need to use try? or add inside do-catch
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                // Decode data and add to items array
                lists = try decoder.decode([Checklist].self, from: data)
                sortChecklists()
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
    
    // Set default value for default value in userdefault
    func registerDefault() {
        let dictionary = [
            "ChecklistIndex" : -1,
            "FirstTime": true
        ] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
        }
    }
    
    func sortChecklists() {
        lists.sort { firstItem, secondItem in
            return firstItem.name.localizedStandardCompare(secondItem.name) == .orderedAscending
        }
    }
    
    // class method - this kind of method applies to the class as a whole - almost like static func
    // if not using class then its called instance method
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        return itemID
    }
}
