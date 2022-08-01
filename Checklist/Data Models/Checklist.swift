//
//  Checklist.swift
//  Checklist
//
//  Created by Ardian Pramudya Alphita on 14/07/22.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var items = [ChecklistItem]()
    var iconName = "No Icon"
    
    init(name: String, iconName: String = "No Icon") {
        super.init()
        self.name = name
        self.iconName = iconName
    }
    
    func countUncheckedItem() -> Int {
        // reduce is a method that looks at each item in the array and performs the code in the block
        // 0 -> initial value
        return items.reduce(0) { partialResult, item in
            partialResult + (item.checked ? 0 : 1)
        }
    }
}
