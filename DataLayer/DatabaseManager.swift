//
//  DatabaseManager.swift
//  DataLayer
//
//  Created by Subhadeep Pal on 03/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit
import CoreData

public protocol DatabaseManagerProtocol {
    var context : NSManagedObjectContext {get}
    func save()
}

open class DatabaseManager: NSObject {
    
    open static let shared : DatabaseManager = DatabaseManager()
    
    public var dataSource : DatabaseManagerProtocol!
   
    
    //MARK: - Concern
    public enum HealthConcernStatusType: Int {
        case inControl = 0
        case notInControl
        case resolved
        static let values = [
            inControl : "In Control",
            notInControl: "Not In Control",
            resolved: "Resolved"
        ]
        public func stringValue() -> String {
            return HealthConcernStatusType.values[self] ?? ""
        }
    }
    
    public enum ConcernType: Int {
        case healthConcern = 0
        case fitnessGoals
        static let values = [
            healthConcern : "Health Concern",
            fitnessGoals: "Fitness Goals"
        ]
        public func stringValue() -> String {
            return ConcernType.values[self] ?? ""
        }
    }
    
    
    
    // ADD New Health Concern
    open func addNewHealthConcern(title: String, status: String, note: String, type: ConcernType){
        let healthConcern = HealthConcern(context: dataSource.context)
        healthConcern.title = title
        healthConcern.status = status
        healthConcern.note = note
        healthConcern.concernType = Int16(type.rawValue)
        dataSource.save()
    }
    
    // FETCH All Health Concerns Saved In Core Data
    open func fetchHealthConcerns() -> [HealthConcern]{
        let healthConcerns: [HealthConcern]? = try? dataSource.context.fetch(HealthConcern.fetchRequest())
        return healthConcerns ?? []
    }
    
    
    // FETCH Health Concerns Based On Status
    open func fetchHealthConcerns(basedOnStatus status: HealthConcernStatusType, andType type:ConcernType) -> [HealthConcern]{
        let fetchRequest : NSFetchRequest<HealthConcern> = HealthConcern.fetchRequest()
        let concernTypePredicate = NSPredicate(format: "concernType == %d", Int16(type.rawValue))
        let statuspredicate = NSPredicate(format: "status == %@", status.stringValue())
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [concernTypePredicate,statuspredicate])
        let healthConcerns: [HealthConcern]? = try? dataSource.context.fetch(fetchRequest)
        return healthConcerns ?? []
    }
    
    open func fetchHealthConcerns(basedOnType type:ConcernType) -> [HealthConcern]{
        let fetchRequest : NSFetchRequest<HealthConcern> = HealthConcern.fetchRequest()
        let concernTypePredicate = NSPredicate(format: "concernType == %d", Int16(type.rawValue))
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [concernTypePredicate])
        let healthConcerns: [HealthConcern]? = try? dataSource.context.fetch(fetchRequest)
        return healthConcerns ?? []
    }
    
    
    // Update Health Concern
    open func update(healthConcern: HealthConcern) {
        dataSource.save()
    }
    
    
    // DELETE Health Concern From Core Data
    // TODO check for action plans then only allow deletion
    open func deleteHealthConcern(title: String){
        let fetchRequest : NSFetchRequest<HealthConcern> = HealthConcern.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        let fetchedResults : [HealthConcern]? = try? dataSource.context.fetch(fetchRequest)
        guard let healthConcern = fetchedResults?.first else{ return }
        dataSource.context.delete(healthConcern)
    }
    
    //MARK: - Action Plan
    open func createNewActionPlan(title: String, concern: HealthConcern?, category: ActionPlanCategory, note: String?) {
        let actionPlan = ActionPlan(context: dataSource.context)
        actionPlan.title = title
        actionPlan.notes = note
        actionPlan.concern = concern
        actionPlan.category = category.name
        dataSource.save()
    }
    
    open func update(actionPlan: ActionPlan) {
        dataSource.save()
    }
    
    open func fetchActionPlans(basedOnCategory category: ActionPlanCategory) -> [ActionPlan] {
        let fetchReq : NSFetchRequest<ActionPlan> = ActionPlan.fetchRequest()
        let predicate = NSPredicate(format: "category == %@", category.name)
        fetchReq.predicate = predicate
        let actionPlans : [ActionPlan]? = try? dataSource.context.fetch(fetchReq)
        return actionPlans ?? []
    }
    
    open func fetchActionPlans(basedOnCategory category: ActionPlanCategory, andConcern concern: HealthConcern) -> [ActionPlan]{
        let fetchReq : NSFetchRequest<ActionPlan> = ActionPlan.fetchRequest()
        let predicate1 = NSPredicate(format: "category == %@", category.name)
        let predicate2 = NSPredicate(format: "concern == %@", concern)
        fetchReq.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        let actionPlans : [ActionPlan]? = try? dataSource.context.fetch(fetchReq)
        return actionPlans ?? []
    }
    
    open func fetchAllActionPlans() -> [ActionPlan]{
        let fetchReq : NSFetchRequest<ActionPlan> = ActionPlan.fetchRequest()
        let actionPlans : [ActionPlan]? = try? dataSource.context.fetch(fetchReq)
        return actionPlans ?? []
    }

    // DELETE Action Plan
    open func delete(actionPlan: ActionPlan) {
        dataSource.context.delete(actionPlan)
        dataSource.save()
    }
    
    // MARK: - Reminder
    open func createNewReminder(title: String, note: String, actionPlan: ActionPlan){
        let reminder = Reminder(context: dataSource.context)
        reminder.title = title
        reminder.note = note
        reminder.actionPlan = actionPlan
        dataSource.save()
    }
    
    open func update(reminder: Reminder){
        dataSource.save()
    }
    
    open func delete(reminder: Reminder) {
        dataSource.context.delete(reminder)
        dataSource.save()
    }
    
    open func fetchAllReminders() -> [Reminder]{
        let fetchReq : NSFetchRequest<Reminder> = Reminder.fetchRequest()
        let reminders : [Reminder]? = try? dataSource.context.fetch(fetchReq)
        return reminders ?? []
    }
    
    open func fetchReminderBasedOnActionPlanCategory(category: String) -> [Reminder]{
        let fetchReq : NSFetchRequest<Reminder> = Reminder.fetchRequest()
        let predicate = NSPredicate(format: "actionPlan.category == %@", category)
        fetchReq.predicate = predicate
        let reminders : [Reminder]? = try? dataSource.context.fetch(fetchReq)
        return reminders ?? []
    }

}
