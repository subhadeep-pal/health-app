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

    func scheduleNotification(reminder: Reminder) {
        guard let title = reminder.actionPlan?.title else {return}
        guard let message = reminder.title else {return}
        guard let startDate = reminder.startDate as Date? else {return}
        
        switch reminder.type {
        case .Once:
            scheduleNotificationOnceType(title: title, messsage: message, date: startDate)
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
    
    func scheduleNotificationOnceType(title: String, messsage: String, date: Date) {
        
    }
    
    func scheduleNotificationWeeklyType(startDate: Date, days: [Day]) {
        
    }
    
    func scheduleNotificationMonthlyType(startDate: Date, months: [Month]) {
        
    }
    
    
}
