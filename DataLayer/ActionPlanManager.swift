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
}

open class ActionPlanManager: NSObject {
    
    public override init() {
    }
    
    public static var shared : ActionPlanManager = ActionPlanManager()
    
    private lazy var dictionary : Dictionary<String, Array<String>>? = {
        guard let bundle = Bundle(identifier: "com.virtual-elf.DataLayer") else {return nil}
        guard let pathString = bundle.path(forResource: "ActionPlanTypes", ofType: "plist") else {return nil}
        guard let dict = NSDictionary(contentsOfFile: pathString) as? Dictionary<String, Array<String>> else {return nil}
        return dict
    } ()
    
    public func getActionPlanCategories(forType type: DatabaseManager.ActionPlansType) -> [ActionPlanCategory] {
        guard let dictionary = self.dictionary else {return []}
        guard let arrayOfCategories = dictionary[type.stringValue()] else {return []}
        
        var returnArray = [ActionPlanCategory]()
        for item in arrayOfCategories {
            let category = ActionPlanCategory(name: item)
            returnArray.append(category)
        }
        return returnArray
    }

}
