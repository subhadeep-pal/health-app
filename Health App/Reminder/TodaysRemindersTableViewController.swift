//
//  TodaysRemindersTableViewController.swift
//  Health App
//
//  Created by Subhadeep Pal on 01/11/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit
import DataLayer
class TodaysRemindersTableViewController: UITableViewController {
    
    @IBOutlet var headerView: UIView!
    var medicalReminders : [Reminder] {
        return DatabaseManager.shared.fetchReminderBasedOnCurrentDate(andActionPlanType: ActionPlanManager.ActionPlansType.MedicalIntervention.stringValue())
    }
    var lifestyleReminders : [Reminder] {
        return DatabaseManager.shared.fetchReminderBasedOnCurrentDate(andActionPlanType: ActionPlanManager.ActionPlansType.LifestyleChanges.stringValue())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        headerView.sizeToFit()
        self.tableView.tableHeaderView = headerView
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let reminderType = DatabaseManager.ReminderType(rawValue: section) else {return nil}
        switch reminderType{
        case .medicalReminder:
            return medicalReminders.count > 0 ? reminderType.stringValue() : nil
        case .lifestyleReminder:
            return lifestyleReminders.count > 0 ? reminderType.stringValue() : nil
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let reminderType = DatabaseManager.ReminderType(rawValue: section) else {return 0}
        switch reminderType{
        case .medicalReminder:
            return medicalReminders.count
        case .lifestyleReminder:
            return lifestyleReminders.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currentReminder", for: indexPath)
        guard let reminderType = DatabaseManager.ReminderType(rawValue: indexPath.section) else {return cell}
        switch reminderType {
        case .medicalReminder:
            cell.textLabel?.text = medicalReminders[indexPath.row].title
        case .lifestyleReminder :
            cell.textLabel?.text = lifestyleReminders[indexPath.row].title
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
//            cell.tintColor = UIColor.init(red: 112/255, green: 245/255, blue: 200/255, alpha: 1.0)
        let alert = UIAlertController(title: "Confirm", message: "Do you really want to remove the pending notifications for this reminder?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){UIAlertAction in
                cell.accessoryType = .checkmark
                cell.selectionStyle = .none
                guard let reminderType = DatabaseManager.ReminderType(rawValue: indexPath.section) else {return}
                switch reminderType {
                case .medicalReminder:
                    RecurranceManager.shared.removeTodaysNotificationsFor(reminder: self.medicalReminders[indexPath.row] )
                case .lifestyleReminder :
                    RecurranceManager.shared.removeTodaysNotificationsFor(reminder: self.lifestyleReminders[indexPath.row] )
                }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default){UIAlertAction in
           cell.isSelected = false
        })
        self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = .none
             cell.selectionStyle = .default
//            guard let reminderType = DatabaseManager.ReminderType(rawValue: indexPath.section) else {return}
//            switch reminderType {
//            case .medicalReminder:
//                RecurranceManager.shared.scheduleNotification(reminder: medicalReminders[indexPath.row])
//            case .lifestyleReminder :
//                RecurranceManager.shared.scheduleNotification(reminder: lifestyleReminders[indexPath.row])
//            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
