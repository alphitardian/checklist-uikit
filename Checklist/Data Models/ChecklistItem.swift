//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Ardian Pramudya Alphita on 10/07/22.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    override init() {
        super.init()
        itemID = DataModel.nextChecklistItemID()
    }
    
    deinit {
        removeNotification()
    }
    
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = .default
            
            // Extract time from dueDate
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: dueDate
            )
            // UNCalendarNotificationTrigger will show notification at specified date
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(
                identifier: "\(itemID)",
                content: content,
                trigger: trigger
            )
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("create notification")
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
}
