//
//  Utilities.swift
//  Health App
//
//  Created by Subhadeep Pal on 01/11/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit

class Utilities: NSObject {
    
    static var shared : Utilities = Utilities()
    
    
    func stringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func dateFromString(str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: str)
    }

}
