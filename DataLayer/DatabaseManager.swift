//
//  DatabaseManager.swift
//  DataLayer
//
//  Created by Subhadeep Pal on 03/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit
import CoreData

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
        func stringValue() -> String {
            guard let value = HealthConcernStatusType.values[self] else {return ""}
            return value
        }
    }
    var getContect : NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveContext(){
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    // ADD New Health Concern
    open func addNewHealthConcern(title: String, status: String, note: String){
        let healthConcern = HealthConcern(context: getContect)
        healthConcern.title = title
        healthConcern.status = status
        healthConcern.note = note
        saveContext()
    }
    
    // FETCH All Health Concerns Saved In Core Data
    open func fetchHealthConcerns() -> [HealthConcern]{
        let healthConcerns: [HealthConcern]? = try? getContect.fetch(HealthConcern.fetchRequest())
        return healthConcerns ?? []
    }
    
    
    // FETCH Health Concerns Based On Status
    open func fetchHealthConcernsBasedOnStatus(status: HealthConcernStatusType) -> [HealthConcern]{
        let fetchRequest : NSFetchRequest<HealthConcern> = HealthConcern.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "status == %@", status.stringValue())
        let healthConcerns: [HealthConcern]? = try? getContect.fetch(fetchRequest)
        return healthConcerns ?? []
    }
    
    
    // UPDATE If Present Else ADD
    open func addOrUpdateHealthConcern(title: String, status: String, note: String){
        
        let fetchRequest : NSFetchRequest<HealthConcern> = HealthConcern.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        let fetchedResults : [HealthConcern]? = try? getContect.fetch(fetchRequest)
        
        guard let healthConcern = fetchedResults.first else {
            addNewHealthConcern(title: title, status: status, note: note)
            return
        }
        healthConcern.title = title
        healthConcern.status = status
        healthConcern.note = note
        
        // Is there need to saveContext() ?
    }
    
    // DELETE Health Concern From Core Data
    open func deleteHealthConcern(title: String){
        do{
        let fetchRequest : NSFetchRequest<HealthConcern> = HealthConcern.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        let fetchedResults = try getContect.fetch(fetchRequest)
        for object in fetchedResults {
            getContect.delete(object)
            }
        }catch{
            print("Can't find object")
        }
    }
}
