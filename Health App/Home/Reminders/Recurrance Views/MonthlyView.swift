//
//  MonthlyView.swift
//  Health App
//
//  Created by Subhadeep Pal on 28/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit
import DataLayer

class MonthlyView: RecurrenceView, CheckBoxProtocol {
    
    @IBOutlet weak var titleTextLabel: UILabel!
    
    @IBOutlet var checkBoxes: [CheckBox]!
    
    var selectedMonthsSet = Set<RecurranceManager.Month>()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        recurranceType = .Monthly
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        titleTextLabel.text = recurranceType.stringValue()
        loadCheckBoxes()
        if let selectedMonths = self.selectedMonths {
            for months in selectedMonths{
                checkBoxes[months.rawValue].set(selected: true)
            }
        }
    }
    
    func loadCheckBoxes() {
        for item in checkBoxes {
            item.set(title: (RecurranceManager.Month(rawValue: item.tag)?.stringValue()) ?? "Error")
            item.delegate = self
        }
    }
    
    func tappedCheckbox(withTag tag: Int) {
        guard let month = RecurranceManager.Month(rawValue: tag) else {return}
        if selectedMonthsSet.contains(month) {
            selectedMonthsSet.remove(month)
        } else {
            selectedMonthsSet.insert(month)
        }
        
        selectedMonths = Array(selectedMonthsSet)
        
    }
}
