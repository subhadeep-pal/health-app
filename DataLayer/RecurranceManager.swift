//
//  RecurranceManager.swift
//  DataLayer
//
//  Created by Subhadeep Pal on 28/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit
import UserNotifications

open class RecurranceManager: NSObject {
    
    public enum RecurranceType: Int {
        case Once = 0
        case Weekly
        case Monthly
        
        static let values = [
            Once : "Just Once",
            Weekly: "Weekly",
            Monthly : "Monthly"
        ]
        public func stringValue() -> String {
            return RecurranceType.values[self] ?? ""
        }
    }
    
    public enum Day: Int {
        case Monday = 0
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
        case Saturday
        case Sunday
        
        static let values = [
            Monday : "Monday",
            Tuesday: "Tuesday",
            Wednesday : "Wednesday",
            Thursday: "Thursday",
            Friday : "Friday",
            Saturday: "Saturday",
            Sunday : "Sunday"
        ]
        public func stringValue() -> String {
            return Day.values[self] ?? ""
        }
    }
    
    
    public enum Month: Int {
        case January = 0
        case February
        case March
        case April
        case May
        case June
        case July
        case August
        case September
        case October
        case November
        case December
        
        static let values = [
            January : "January",
            February: "February",
            March : "March",
            April: "April",
            May : "May",
            June: "June",
            July : "July",
            August : "August",
            September: "September",
            October : "October",
            November: "November",
            December : "December"
        ]
        public func stringValue() -> String {
            return Month.values[self] ?? ""
        }
    }
    
    static var shared = RecurranceManager()

    func scheduleNotification(reminder: Reminder) {
        guard let title = reminder.actionPlan?.title else {return}
        guard let message = reminder.title else {return}
        guard let startDate = reminder.startDate as Date? else {return}
        guard let identifierText = reminder.identifierText else {return}
        switch reminder.type {
        case .Once:
            scheduleNotificationOnceType(title: title, messsage: message, identifierText: identifierText, date: startDate)
        case .Weekly:
            guard let days = reminder.weeklyDays else {
                //show error
                return
            }
            scheduleNotificationWeeklyType(startDate: startDate, days: days)
        case .Monthly:
            guard let months = reminder.yearlyMonths else {
                // show error
                return
            }
            scheduleNotificationMonthlyType(startDate: startDate, months: months)
        }
    }
    
    func scheduleNotificationOnceType(title: String, messsage: String, identifierText: String, date: Date) {
        for i in stride(from: 0, to: 23, by: 2) {
            let notificationContent = UNMutableNotificationContent()
            
            notificationContent.body = messsage
            notificationContent.title = "\(title) \(i)"
            
            let unitFlags : Set<Calendar.Component> = [.day, .month, .year]
            let components = Calendar.current.dateComponents(unitFlags, from: date)
            
            var dateComponent = DateComponents()
            dateComponent.day = components.day
            dateComponent.month = components.month
            dateComponent.year = components.year
            dateComponent.hour = i
            dateComponent.minute = 0
            dateComponent.second = 0
            
            dateComponent.calendar = Calendar(identifier: .gregorian)
            dateComponent.timeZone = NSTimeZone.default
            
            let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
            
            let req = UNNotificationRequest(identifier: "\(identifierText)_\(components.day!)_\(components.month!)_\(components.year!)", content: notificationContent, trigger: notificationTrigger)
            print(req.identifier)
            UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
        }
    }
    
    func scheduleNotificationWeeklyType(startDate: Date, days: [Day]) {
        
    }
    
    func scheduleNotificationMonthlyType(startDate: Date, months: [Month]) {
        
    }
    
    
    func removeTodaysNotificationsFor(reminder: Reminder) {
        let date = Date()
        
        guard let identifierText = reminder.identifierText else {return}
        
        let unitFlags : Set<Calendar.Component> = [.day, .month, .year]
        let components = Calendar.current.dateComponents(unitFlags, from: date)
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(identifierText)_\(components.day!)_\(components.month!)_\(components.year!)"])
    }
    
}
