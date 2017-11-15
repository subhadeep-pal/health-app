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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "currentReminder", for: indexPath) as? TodaysRemindersTableViewCell else { return UITableViewCell()}
        guard let reminderType = DatabaseManager.ReminderType(rawValue: indexPath.section) else {return cell}
        switch reminderType {
        case .medicalReminder:
            cell.reminderTitleLabel.text = medicalReminders[indexPath.row].title
//            cell.textLabel?.text = medicalReminders[indexPath.row].title
        case .lifestyleReminder :
            cell.reminderTitleLabel.text = lifestyleReminders[indexPath.row].title
//            cell.textLabel?.text = lifestyleReminders[indexPath.row].title
        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
