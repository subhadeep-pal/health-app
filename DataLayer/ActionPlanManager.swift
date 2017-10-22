//
//  ActionPlanManager.swift
//  DataLayer
//
//  Created by Subhadeep Pal on 20/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit

public struct ActionPlanCategory {
    public var name: String
    public var type: ActionPlanManager.ActionPlansType
}

open class ActionPlanManager: NSObject {
    
    public enum ActionPlansType: Int {
        case MedicalIntervention = 0
        case LifestyleChanges
        case Habits
        static let values = [
            MedicalIntervention : "Medical Intervention",
            LifestyleChanges: "Lifestyle Changes",
            Habits: "Habits"
        ]
        public func stringValue() -> String {
            return ActionPlansType.values[self] ?? ""
        }
    }
    
    public override init() {
    }
    
    public static var shared : ActionPlanManager = ActionPlanManager()
    
    private lazy var dictionary : Dictionary<String, Array<String>>? = {
        guard let bundle = Bundle(identifier: "com.always.wired.DataLayer") else {return nil}
        guard let pathString = bundle.path(forResource: "ActionPlanTypes", ofType: "plist") else {return nil}
        guard let dict = NSDictionary(contentsOfFile: pathString) as? Dictionary<String, Array<String>> else {return nil}
        return dict
    } ()
    
    public func getActionPlanCategories(forType type: ActionPlansType) -> [ActionPlanCategory] {
        guard let dictionary = self.dictionary else {return []}
        guard let arrayOfCategories = dictionary[type.stringValue()] else {return []}
        
        var returnArray = [ActionPlanCategory]()
        for item in arrayOfCategories {
            let category = ActionPlanCategory(name: item, type: type)
            returnArray.append(category)
        }
        return returnArray
    }

}
