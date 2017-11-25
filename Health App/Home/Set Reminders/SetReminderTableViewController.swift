//
//  SetReminderTableViewController.swift
//  Health App
//
//  Created by Koushik Dutta on 29/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit
import DataLayer
class SetReminderTableViewController: UITableViewController {
    
    @IBOutlet var headerView: UIView!
    var reminders : [Reminder] {
        return DatabaseManager.shared.fetchAllReminders()
    }
    var dataKeys : [String] = []
    var data : Dictionary<String, [Reminder]>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.sizeToFit()
        self.tableView.tableHeaderView = headerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        parseData()
        self.tableView.reloadData()
    }
    
    private func parseData(){
        self.data = [:]
        self.dataKeys = []
        var setActionPlan : Set<ActionPlan> = []
        for item in reminders {
            setActionPlan.insert(item.actionPlan!)
        }
        var categorySet : Set<String> = []
        for actionPlan in setActionPlan{
            categorySet.insert(actionPlan.category ?? "")
        }
        var returnDict : Dictionary<String, [Reminder]> = [:]
        for category in categorySet{
            returnDict[category] = DatabaseManager.shared.fetchReminderBasedOnActionPlanCategory(category: category)
            dataKeys.append(category)
        }
        self.data = returnDict
    }
    
    @IBAction func addReminderTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addReminder", sender: sender)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataKeys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let actionPlanKey = dataKeys[section]
        return data[actionPlanKey]?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let actionPlanKey = dataKeys[section]
//        return actionPlanKey.category
        return actionPlanKey
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath)
        let actionPlanKey = dataKeys[indexPath.section]
        guard let reminders = data[actionPlanKey]?[indexPath.row] else {return cell}
        
        cell.textLabel?.text = reminders.title
        
        return cell
    }
    
    // MARK: Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let actionPlanKey = dataKeys[indexPath.section]
        guard let reminder = data[actionPlanKey]?[indexPath.row] else {return}
        self.performSegue(withIdentifier: "addReminder", sender: reminder)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addReminder" {
            guard let destinationVC = segue.destination as? AddReminderViewController,
                let reminder = sender as? Reminder else {return}
            destinationVC.reminder = reminder
        }
    }
}

