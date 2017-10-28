//
//  RecurranceViewController.swift
//  Health App
//
//  Created by Subhadeep Pal on 28/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit
import DataLayer

class RecurranceViewController: UIViewController {

    @IBOutlet var recurranceViews: [RecurrenceView]!
    
    var selectedRecurrance : RecurrenceView? {
        didSet {
            guard let view = selectedRecurrance else {return}
            selectedView(view: view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        case .none:
            // show error
            return
        case .some(_):
            // show error
            return
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        
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
