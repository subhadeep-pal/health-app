//
//  RecurranceViewController.swift
//  Health App
//
//  Created by Subhadeep Pal on 28/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit
import DataLayer

protocol RecurranceSelectionProtocol: class {
    func selectedRecurrance(type: RecurranceManager.RecurranceType, startDate: Date, monthly: [RecurranceManager.Month]?, weekly: [RecurranceManager.Day]?)
    
    func cancelTapped()
}

class RecurranceViewController: UIViewController {

    @IBOutlet var recurranceViews: [RecurrenceView]!
    weak var delegate : RecurranceSelectionProtocol?
    var reminder : Reminder?
    var selectedRecurrance : RecurrenceView? {
        didSet {
            guard let view = selectedRecurrance else {return}
            selectedView(view: view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }
    
    func initView(){
        if let reminder = reminder{
            recurranceViews[reminder.recurranceType.hashValue].isSelected = true
            recurranceViews[reminder.recurranceType.hashValue].startDateField.text = Utilities.shared.stringFromDate(date: reminder.startDate as Date!)
            
            if let days = reminder.days{
                var daysArray : [RecurranceManager.Day] = []
                let selectedDays = days.components(separatedBy: "-").flatMap { Int($0) }
                for day in selectedDays{
                    daysArray.append(RecurranceManager.Day(rawValue: day)!)
                }
                recurranceViews[reminder.recurranceType.hashValue].selectedDays = daysArray
            }
            
            if let months = reminder.months{
                var monthsArray : [RecurranceManager.Month] = []
                let selectedMonths = months.components(separatedBy: "-").flatMap { Int($0) }
                for month in selectedMonths{
                    monthsArray.append(RecurranceManager.Month(rawValue: month)!)
                }
                recurranceViews[reminder.recurranceType.hashValue].selectedMonths = monthsArray
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let recurranceView = selectedRecurrance else {return}
        switch recurranceView.recurranceType {
        case .Once:
            guard let date = recurranceView.selectedDate else {
                //show error
                return
            }
            self.delegate?.selectedRecurrance(type: .Once, startDate: date, monthly: nil, weekly: nil)
        case .Monthly:
            guard let date = recurranceView.selectedDate else {
                //show error
                return
            }
            guard let months = recurranceView.selectedMonths,
                months.count > 0
                else {
                // show error
                    return
            }
            self.delegate?.selectedRecurrance(type: .Monthly, startDate: date, monthly: months, weekly: nil)
        case .Weekly:
            guard let date = recurranceView.selectedDate else {
                //show error
                return
            }
            guard let days = recurranceView.selectedDays,
                days.count > 0
                else {
                    // show error
                    return
            }
            self.delegate?.selectedRecurrance(type: .Weekly, startDate: date, monthly: nil, weekly: days)
        case .none:
            // show error
            return
        case .some(_):
            // show error
            return
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.delegate?.cancelTapped()
    }
    
    @IBAction func radioButtonTapped(_ sender: UIButton) {
        selectedRecurrance = recurranceViews[sender.tag]
        
    }
    
    func selectedView(view: RecurrenceView) {
        for item in recurranceViews {
            guard item != view else {
                view.isSelected = true
                continue
            }
            item.isSelected = false
        }
    }
    
}
