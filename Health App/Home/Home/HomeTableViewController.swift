//
//  HomeTableViewController.swift
//  Health App
//
//  Created by Subhadeep Pal on 07/11/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit
import DataLayer

class HomeTableViewController: UITableViewController {
    
    @IBOutlet weak var dateBarButtonItem: UIBarButtonItem!
    let images = [#imageLiteral(resourceName: "health-concerns"),#imageLiteral(resourceName: "fitness-goals"),#imageLiteral(resourceName: "action-plans"),#imageLiteral(resourceName: "set-reminders")]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        let dateString = dateFormatter.string(from: Date())
        self.dateBarButtonItem.title = dateString
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as? HomeTableViewCell else { return UITableViewCell()}

        // Configure the cell...
        cell.backgroundImageVuew.image = images[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "concerns", sender: DatabaseManager.ConcernType.healthConcern)
        case 1:
            performSegue(withIdentifier: "concerns", sender: DatabaseManager.ConcernType.fitnessGoals)
        case 2:
            performSegue(withIdentifier: "actionPlan", sender: nil)
        case 3:
            performSegue(withIdentifier: "reminder", sender: nil)
        default:
            return
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "concerns" {
            guard let destinationVC = segue.destination as? HealthConcernsListVC,
                let concertnType = sender as? DatabaseManager.ConcernType  else {return}
            destinationVC.type = concertnType
        }
    }
    

}
