//
//  HealthConcernsListVC.swift
//  Health App
//
//  Created by Koushik Dutta on 07/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit
import DataLayer

class HealthConcernsListVC: UIViewController {
    
    var inControlStatus: [HealthConcern] {
        return DatabaseManager.shared.fetchHealthConcernsBasedOnStatus(status: .inControl)
    }
    
    var notInControlStatus: [HealthConcern] {
        return DatabaseManager.shared.fetchHealthConcernsBasedOnStatus(status: .notInControl)
    }
    
    var resolvedStatus: [HealthConcern] {
        return DatabaseManager.shared.fetchHealthConcernsBasedOnStatus(status: .resolved)
    }
    
    @IBOutlet weak var healthConcernsTableView: UITableView!
    @IBOutlet weak var addNewHealthConcernBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchBasedOnStatus()
        healthConcernsTableView.reloadData()
    }
    
    func fetchBasedOnStatus(){
        
    }
    
    @IBAction func addNewHealthConcernBarButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "AddOrUpdateConcern", sender: sender)
    }
// MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddOrUpdateConcern" {
            let destinationViewController = segue.destination as! AddOrUpdateHealthConcernVC
            destinationViewController.healthConcern = sender as? HealthConcern
        }
    }
}

// MARK: - TableView DataSource
extension HealthConcernsListVC: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let status = DatabaseManager.HealthConcernStatusType(rawValue: section) else {return nil}
        switch status{
        case .inControl:
            return inControlStatus.count > 0 ? status.stringValue() : nil
        case .notInControl:
            return notInControlStatus.count > 0 ? status.stringValue() : nil
        case .resolved:
            return resolvedStatus.count > 0 ? status.stringValue() : nil
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let status = DatabaseManager.HealthConcernStatusType(rawValue: section) else {return 0}
        switch status{
        case .inControl:
            return inControlStatus.count
        case .notInControl:
            return notInControlStatus.count
        case .resolved:
            return resolvedStatus.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "healthConcernCell", for: indexPath)
        guard let status = DatabaseManager.HealthConcernStatusType(rawValue: indexPath.section) else {return cell}
        switch status{
        case .inControl:
            cell.textLabel?.text = inControlStatus[indexPath.row].title
        case .notInControl:
            cell.textLabel?.text = notInControlStatus[indexPath.row].title
        case .resolved:
            cell.textLabel?.text = resolvedStatus[indexPath.row].title
        }
        return cell
    }
}

// MARK: - TableView Delegate
extension HealthConcernsListVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var healthConcern: HealthConcern?
        guard let status = DatabaseManager.HealthConcernStatusType(rawValue: indexPath.section) else {return}
        switch status{
        case .inControl:
            healthConcern = inControlStatus[indexPath.row]
        case .notInControl:
            healthConcern = notInControlStatus[indexPath.row]
        case .resolved:
            healthConcern = resolvedStatus[indexPath.row]
        }
        performSegue(withIdentifier: "AddOrUpdateConcern", sender: healthConcern)
    }
}

