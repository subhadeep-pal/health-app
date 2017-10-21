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
    
    public var dataSource : DatabaseManagerProtocol!
    
    // ADD New Health Concern
    open func addNewHealthConcern(title: String, status: String, note: String, type: ConcernType){
        let healthConcern = HealthConcern(context: dataSource.context)
        healthConcern.title = title
        healthConcern.status = status
        healthConcern.note = note
        healthConcern.concernType = type.stringValue()
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
        let concernTypePredicate = NSPredicate(format: "concernType == %@", type.stringValue())
        let statuspredicate = NSPredicate(format: "status == %@", status.stringValue())
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [concernTypePredicate,statuspredicate])
        let healthConcerns: [HealthConcern]? = try? dataSource.context.fetch(fetchRequest)
        return healthConcerns ?? []
    }
    
    
    // UPDATE If Present Else ADD
    open func addOrUpdateHealthConcern(title: String, status: String, note: String, type: ConcernType){
        
        let fetchRequest : NSFetchRequest<HealthConcern> = HealthConcern.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        let fetchedResults : [HealthConcern]? = try? dataSource.context.fetch(fetchRequest)
        
        guard let healthConcern = fetchedResults?.first else {
            addNewHealthConcern(title: title, status: status, note: note, type: type)
            return
        }
        healthConcern.title = title
        healthConcern.status = status
        healthConcern.note = note
        healthConcern.concernType = type.stringValue()
    }
    
    // DELETE Health Concern From Core Data
    open func deleteHealthConcern(title: String){
        let fetchRequest : NSFetchRequest<HealthConcern> = HealthConcern.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        let fetchedResults : [HealthConcern]? = try? dataSource.context.fetch(fetchRequest)
        guard let healthConcern = fetchedResults?.first else{ return }
        dataSource.context.delete(healthConcern)
    }
}
