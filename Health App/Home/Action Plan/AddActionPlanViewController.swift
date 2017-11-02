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
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var concernTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var createReminderViewHeightConstraint: NSLayoutConstraint!
    
    var healthConcern : HealthConcern?
    var category: ActionPlanCategory?
    
    let categoryPicker = UIPickerView()
    let healthConcernPicker = UIPickerView()
    
    var dataForCategoryPicker: [ActionPlanCategory]?
    var dataForConcernPicker: [HealthConcern]?
    
    var actionPlan: ActionPlan?

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
            
        }
        
        if let actionPlan = actionPlan{
            self.title = actionPlan.title
            self.titleTextField.text = actionPlan.title
            self.concernTextField.text = actionPlan.concern?.title
            self.noteTextView.text = actionPlan.notes
            self.healthConcern = actionPlan.concern
            self.deleteButton.isEnabled = true
            createReminderViewHeightConstraint.constant = 36
        } else {
            self.deleteButton.isEnabled = false
            createReminderViewHeightConstraint.constant = 0
            self.title = "New Action Plan"
        }
    }

    @IBAction func createReminderTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "addReminder", sender: actionPlan)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addReminder" {
            guard let destinationVC = segue.destination as? AddReminderViewController,
                let actionPlan = sender as? ActionPlan else {return}
            destinationVC.actionPlan = actionPlan
        }
    }

    @IBAction func emptyTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let title = titleTextField.text,
            !title.isEmpty else {
            // show error on titleTextField
            return
        }
        guard let category = category else {
            //show error
            return
        }
        
        var selectedconcern: HealthConcern? = nil
        if category.type != .Habits {
            guard let concern = healthConcern else {
                // show error in concern
                return
            }
            selectedconcern = concern
        } else {
            selectedconcern = nil
        }
        
        if let actionPlan = actionPlan {
            // update
            actionPlan.category = category.name
            actionPlan.categoryType = category.type.stringValue()
            actionPlan.title = title
            actionPlan.concern = selectedconcern
            actionPlan.notes = noteTextView.text
            DatabaseManager.shared.update(actionPlan: actionPlan)
        } else {
            // create new
            DatabaseManager.shared.createNewActionPlan(title: title, concern: selectedconcern, category: category, note: noteTextView.text)
        }
        showSuccessMessage()
    }
    @IBAction func deleteTapped(_ sender: UIButton) {
        DatabaseManager.shared.delete(actionPlan: self.actionPlan!)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showSuccessMessage() {
        let alert = UIAlertController(title: "", message: "Saved Successfully", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){UIAlertAction in
            self.navigationController?.popViewController(animated: true)
        })
        self.present(alert, animated: true, completion: nil)
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
            healthConcern = dataForConcernPicker?[row]
        case categoryPicker:
            categoryTextField.text = dataForCategoryPicker?[row].name
            category = dataForCategoryPicker?[row]
        default:
            return
        }
    }
}

