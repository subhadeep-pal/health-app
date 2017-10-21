//
//  AddActionPlanViewController.swift
//  Health App
//
//  Created by Subhadeep Pal on 21/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit
import DataLayer

class AddActionPlanViewController: UIViewController {
    
    var healthConcern : HealthConcern?
    var category: Category?
    
    let categoryPicker = UIPickerView()
    let healthConcernPicker = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initView() {
        if let healthConcern = healthConcern {
            //set health concern text field
            
            //disable it
            
        } else if let category = category {
            //set category text field
            
            //disable it
            
        } else {
            
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
