//
//  WeeklyView.swift
//  Health App
//
//  Created by Subhadeep Pal on 28/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit
import DataLayer

class WeeklyView: RecurrenceView, CheckBoxProtocol {
    

    @IBOutlet weak var titleTextLabel: UILabel!
    
    @IBOutlet var checkBoxes: [CheckBox]!
    
    var selectedDaysSet = Set<RecurranceManager.Day>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        recurranceType = .Weekly
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        titleTextLabel.text = recurranceType.stringValue()
        loadCheckBoxes()
        if let selectedDays = self.selectedDays {
            for days in selectedDays{
                checkBoxes[days.rawValue].set(selected: true)
            }
        }
    }
    
    func loadCheckBoxes() {
        for item in checkBoxes {
            item.set(title: (RecurranceManager.Day(rawValue: item.tag)?.stringValue()) ?? "Error")
            item.delegate = self
        }
    }
    
    func tappedCheckbox(withTag tag: Int) {
        guard let day = RecurranceManager.Day(rawValue: tag) else {return}
        if selectedDaysSet.contains(day) {
            selectedDaysSet.remove(day)
        } else {
            selectedDaysSet.insert(day)
        }
        
        selectedDays = Array(selectedDaysSet)
    }

}
