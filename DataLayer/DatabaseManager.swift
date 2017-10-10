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
    
    enum HealthConcernStatusType: Int {
        case inControl = 0
        case notInControl
        case resolved
        
        static let values = [
            inControl : "In Control",
            notInControl: "Not In Control",
            resolved: "Resolved"
        ]
        
        func stringValue() -> String? {
            guard let value = HealthConcernStatusType.values[self] else {return nil}
            return value
        }
    }
    
    var getContect : NSManagedObjectContext {
        get{
            return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
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
        var healthConcerns : [HealthConcern] = []
        do{
            healthConcerns = try getContect.fetch(HealthConcern.fetchRequest())
        }catch{
            print("Failed to fetch data")
        }
        return healthConcerns
    }
    
    // UPDATE If Present Else ADD
    open func addOrUpdateHealthConcern(title: String, status: String, note: String){
        var healthConcern : HealthConcern?
        do {
            let fetchRequest : NSFetchRequest<HealthConcern> = HealthConcern.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title == %@", title)
            let fetchedResults = try getContect.fetch(fetchRequest)
            healthConcern = fetchedResults.first
            }
        catch {
            print ("Failed to fetch data", error)
        }
        if(healthConcern != nil){
            healthConcern?.title = title
            healthConcern?.status = status
            healthConcern?.note = note
        }else{
            addNewHealthConcern(title: title, status: status, note: note)
        }
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
