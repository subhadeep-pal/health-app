//
//  HomeViewController.swift
//  Health App
//
//  Created by Koushik Dutta on 07/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit
import DataLayer

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func fitnessGoalsTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "concerns", sender: DatabaseManager.ConcernType.fitnessGoals)
    }
    
    @IBAction func setReminderTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "reminder", sender: nil)
    }
    @IBAction func healthConcernTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "concerns", sender: DatabaseManager.ConcernType.healthConcern)
    }
    

    @IBAction func actionPlanTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "actionPlan", sender: nil)
    }
}
