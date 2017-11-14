//
//  RecurrenceView.swift
//  Health App
//
//  Created by Subhadeep Pal on 28/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit
import DataLayer


class RecurrenceView: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var radioButtonImageView: UIImageView!
    
    @IBOutlet weak var startDateField: UITextField!
    
    
    
    var datePicker = UIDatePicker()
    
    var selectedDate: Date?
    var selectedDays: [RecurranceManager.Day]?
    var selectedMonths: [RecurranceManager.Month]?

    var recurranceType : RecurranceManager.RecurranceType!
    
    var isSelected : Bool = false {
        didSet {
            if isSelected {
                radioButtonImageView.image = #imageLiteral(resourceName: "ic_radio_button_checked")
            } else {
                radioButtonImageView.image = #imageLiteral(resourceName: "ic_radio_button_unchecked")
            }
        }
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        loadDatePicker()
    }
 
    
    func loadDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        startDateField.inputView = datePicker
        startDateField.delegate = self
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        selectedDate = datePicker.date
        startDateField.text = Utilities.shared.stringFromDate(date: datePicker.date)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard (textField.text != nil) else {return}
        selectedDate = Date()
        startDateField.text = Utilities.shared.stringFromDate(date: Date())
    }
}
