//
//  ActionPlansTableViewController.swift
//  Health App
//
//  Created by Subhadeep Pal on 20/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit
import DataLayer

class ActionPlansTableViewController: UITableViewController {
    
    lazy var medicalInterventionCategories : [ActionPlanCategory] = {
        return ActionPlanManager.shared.getActionPlanCategories(forType: .MedicalIntervention)
    }()
    
    lazy var lifestyleChangesCategories : [ActionPlanCategory] = {
        return ActionPlanManager.shared.getActionPlanCategories(forType: .LifestyleChanges)
    }()
    
    lazy var habitsCategories : [ActionPlanCategory] = {
        return ActionPlanManager.shared.getActionPlanCategories(forType: .Habits)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func categories(forType type: DatabaseManager.ActionPlansType) -> [ActionPlanCategory] {
        switch type {
        case .MedicalIntervention:
            return self.medicalInterventionCategories
        case .LifestyleChanges:
            return self.lifestyleChangesCategories
        case .Habits:
            return self.habitsCategories
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let sectionType = DatabaseManager.ActionPlansType.init(rawValue: section) else {return 0}
        return categories(forType: sectionType).count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionPlanCategoryCell", for: indexPath)
        guard let sectionType = DatabaseManager.ActionPlansType.init(rawValue: indexPath.section) else {return cell}
        
        cell.textLabel?.text = categories(forType: sectionType)[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionType = DatabaseManager.ActionPlansType.init(rawValue: section) else {return nil}
        return sectionType.stringValue()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
