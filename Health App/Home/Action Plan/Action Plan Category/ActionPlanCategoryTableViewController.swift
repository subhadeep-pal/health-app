//
//  ActionPlanCategoryTableViewController.swift
//  Health App
//
//  Created by Subhadeep Pal on 20/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit
import DataLayer

class ActionPlanCategoryTableViewController: UITableViewController {
    
    @IBOutlet var headerView: UIView!
    
    
    var category : ActionPlanCategory!
    
    var actionPlans : [ActionPlan] {
        return DatabaseManager.shared.fetchActionPlans(basedOnCategory:self.category)
    }
    
    var dataKeys : [HealthConcern] = []

    var data : Dictionary<HealthConcern, [ActionPlan]>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.title = category.name
        headerView.sizeToFit()
        self.tableView.tableHeaderView = headerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        parseData()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataKeys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let concernKey = dataKeys[section]
        return data[concernKey]?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "actionPlanCell", for: indexPath)
        let concernKey = dataKeys[indexPath.section]
        guard let actionPlan = data[concernKey]?[indexPath.row] else {return cell}
        
        cell.textLabel?.text = actionPlan.title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let concernKey = dataKeys[indexPath.section]
        guard let actionPlan = data[concernKey]?[indexPath.row] else {return}
        self.performSegue(withIdentifier: "createActionPlan", sender: actionPlan)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let concernKey = dataKeys[section]
        return concernKey.title
    }
    
    func parseData() {
        self.data = [:]
        self.dataKeys = []
        var setConcern : Set<HealthConcern> = []
        for item in actionPlans {
            setConcern.insert(item.concern!)
        }
        var returnDict : Dictionary<HealthConcern, [ActionPlan]> = [:]
        for concern in setConcern {
            returnDict[concern] = DatabaseManager.shared.fetchActionPlans(basedOnCategory: self.category, andConcern: concern)
            dataKeys.append(concern)
        }
        self.data = returnDict
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "createActionPlan" {
            guard let destinavtionVC = segue.destination as? AddActionPlanViewController else {return}
            destinavtionVC.category = self.category
            destinavtionVC.actionPlan = sender as? ActionPlan
        }
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "createActionPlan", sender: nil)
    }
    
}
