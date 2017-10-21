//
//  HealthConcern+CoreDataProperties.swift
//  DataLayer
//
//  Created by Subhadeep Pal on 21/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//
//

import Foundation
import CoreData


extension HealthConcern {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HealthConcern> {
        return NSFetchRequest<HealthConcern>(entityName: "HealthConcern")
    }

    @NSManaged public var concernType: Int16
    @NSManaged public var note: String?
    @NSManaged public var status: String?
    @NSManaged public var title: String?
    
    public var type : DatabaseManager.ConcernType {
        return DatabaseManager.ConcernType(rawValue: Int(concernType))!
    }

}
