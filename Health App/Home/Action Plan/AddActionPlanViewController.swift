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
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var concernTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emptyView: UIView!
    
    var healthConcern : HealthConcern?
    var category: ActionPlanCategory?
    
    let categoryPicker = UIPickerView()
    let healthConcernPicker = UIPickerView()
    
    var dataForCategoryPicker: [ActionPlanCategory]?
    var dataForConcernPicker: [HealthConcern]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
        noteTextView.customizeTextView(placeholderText:"Note", placeholderColor: UIColor.lightGray, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 8.0)
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        healthConcernPicker.delegate = self
        healthConcernPicker.dataSource = self
        
        concernTextField.inputView = healthConcernPicker
        categoryTextField.inputView = categoryPicker
        
        scrollView.keyboardDismissMode = .onDrag
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func initView() {
        if let healthConcern = healthConcern {
            //set health concern text field
            concernTextField.text = healthConcern.title
            //disable it
            concernTextField.isEnabled = false
            
            // provide data for picker
            switch healthConcern.type {
            case .healthConcern:
                dataForCategoryPicker = ActionPlanManager.shared.getActionPlanCategories(forType: .MedicalIntervention)
            case .fitnessGoals:
                dataForCategoryPicker = ActionPlanManager.shared.getActionPlanCategories(forType: .LifestyleChanges)
            }
            
        } else if let category = category {
            //set category text field
            categoryTextField.text = category.name
            //disable it
            categoryTextField.isEnabled = false
            
            // provide data for picker
            switch category.type {
            case .MedicalIntervention:
                // Load only medical concerns
                dataForConcernPicker = DatabaseManager.shared.fetchHealthConcerns(basedOnType: .healthConcern)
                concernTextField.placeholder = DatabaseManager.ConcernType.healthConcern.stringValue().capitalized
            case .LifestyleChanges:
                // Load only from fitness goals
                dataForConcernPicker = DatabaseManager.shared.fetchHealthConcerns(basedOnType: .fitnessGoals)
                concernTextField.placeholder = DatabaseManager.ConcernType.fitnessGoals.stringValue().capitalized
            case .Habits:
                // Hide the field and set some default value
                concernTextField.isEnabled = false
                concernTextField.placeholder = "Not Applicable"
            }
            
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
    @IBAction func emptyTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
}

extension AddActionPlanViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case healthConcernPicker:
            return dataForConcernPicker?.count ?? 0
        case categoryPicker:
            return dataForCategoryPicker?.count ?? 0
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case healthConcernPicker:
            return dataForConcernPicker?[row].title
        case categoryPicker:
            return dataForCategoryPicker?[row].name
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case healthConcernPicker:
            concernTextField.text = dataForConcernPicker?[row].title
        case categoryPicker:
            categoryTextField.text = dataForCategoryPicker?[row].name
        default:
            return
        }
    }
}

