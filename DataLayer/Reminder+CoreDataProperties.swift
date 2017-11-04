//
//  Reminder+CoreDataProperties.swift
//  DataLayer
//
//  Created by Subhadeep Pal on 04/11/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var note: String?
    @NSManaged public var recurranceType: Int16
    @NSManaged public var startDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var days: String?
    @NSManaged public var months: String?
    @NSManaged public var actionPlan: ActionPlan?
    
    public var weeklyDays: [RecurranceManager.Day]? {
        get {
            guard let days = days else {return nil}
            let splitDays = days.components(separatedBy: "-")
            var returnArray = [RecurranceManager.Day]()
            for item in splitDays {
                if let intDay = Int(item),
                    let day = RecurranceManager.Day(rawValue: intDay) {
                    returnArray.append(day)
                }
            }
            return returnArray
        }
        
        set {
            guard let days = newValue else {
                self.days = nil
                return
            }
            
            var returnString = ""
            for item in days {
                if item == days[days.count - 1]{
                   returnString += "\(item.rawValue)"
                    continue
                }
                returnString += "\(item.rawValue)-"
            }
            self.days = returnString
        }
    }
    
    public var yearlyMonths: [RecurranceManager.Month]? {
        get {
            guard let months = months else {return nil}
            let splitMonths = months.components(separatedBy: "-")
            var returnArray = [RecurranceManager.Month]()
            for item in splitMonths {
                if let intMonth = Int(item),
                    let month = RecurranceManager.Month(rawValue: intMonth) {
                    returnArray.append(month)
                }
            }
            return returnArray
        }
        
        set {
            guard let months = newValue else {
                self.months = nil
                return
            }
            
            var returnString = ""
            for item in months {
                if item == months[months.count - 1]{
                    returnString += "\(item.rawValue)"
                    continue
                }
                returnString += "\(item.rawValue)-"
            }
            self.months = returnString
        }
    }
    
    public var type: RecurranceManager.RecurranceType {
        get {
            return RecurranceManager.RecurranceType(rawValue: Int(self.recurranceType)) ?? RecurranceManager.RecurranceType.Once
        }
        set {
            self.recurranceType = Int16(newValue.rawValue)
        }
    }

}
