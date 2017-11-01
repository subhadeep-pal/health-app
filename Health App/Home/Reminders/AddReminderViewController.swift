//
//  AddReminderViewController.swift
//  Health App
//
//  Created by Koushik Dutta on 29/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit
import DataLayer
class AddReminderViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var actionPlanTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var deleteButton: UIButton!
    var actionPlanPicker = UIPickerView()
    var dataForActionPlanPicker : [ActionPlan]?
    var actionPlan: ActionPlan?
    var reminder : Reminder?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        noteTextView.customizeTextView(placeholderText:"Note", placeholderColor: UIColor.lightGray, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 8.0)
        actionPlanPicker.dataSource = self
        actionPlanPicker.delegate = self
        actionPlanTextField.inputView = actionPlanPicker
        scrollView.keyboardDismissMode = .onDrag
        initView()
    }
    
    private func initView(){
        if let actionPlan = self.actionPlan{
            actionPlanTextField.text = actionPlan.category
            actionPlanTextField.isEnabled = false
        }
        dataForActionPlanPicker = DatabaseManager.shared.fetchAllActionPlans()
        
        if let reminder = reminder{
            self.title = reminder.title
            self.titleTextField.text = reminder.title
            self.actionPlanTextField.text = reminder.actionPlan?.title
            self.noteTextView.text = reminder.note
            self.actionPlan = reminder.actionPlan
            self.deleteButton.isEnabled = true
        } else {
            self.deleteButton.isEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let title = titleTextField.text,
            !title.isEmpty else {
                // show error on titleTextField
                return
        }
        guard let actionPlan = actionPlan else{
            // show error
            return
        }
        if let reminder = reminder{
            reminder.title = titleTextField.text
            reminder.note = noteTextView.text
            DatabaseManager.shared.update(reminder: reminder)
        }else{
            DatabaseManager.shared.createNewReminder(title: title, note: noteTextView.text, actionPlan: actionPlan)
        }
        showSuccessMessage()
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        DatabaseManager.shared.delete(reminder: self.reminder!)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func recurrenceTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "recurrence", sender: nil)
    }
    
    private func showSuccessMessage() {
        let alert = UIAlertController(title: "", message: "Saved Successfully", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){UIAlertAction in
            self.navigationController?.popViewController(animated: true)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "recurrence" {
            guard let destinationVC = segue.destination as? RecurranceViewController else {return}
            destinationVC.delegate = self
        }
     }
    
    
}
extension AddReminderViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataForActionPlanPicker?.count ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataForActionPlanPicker?[row].title ?? nil
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        actionPlanTextField.text = dataForActionPlanPicker?[row].title
        actionPlan = dataForActionPlanPicker?[row]
    }
}

extension AddReminderViewController: RecurranceSelectionProtocol {
    func selectedRecurrance(type: RecurranceManager.RecurranceType, startDate: Date, monthly: [RecurranceManager.Month]?, weekly: [RecurranceManager.Day]?) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func cancelTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

