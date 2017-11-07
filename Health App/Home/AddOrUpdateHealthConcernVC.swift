//
//  AddOrUpdateHealthConcernVC.swift
//  Health App
//
//  Created by Koushik Dutta on 07/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit
import DataLayer
class AddOrUpdateHealthConcernVC: UIViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var createActionPlanViewHeightConstraint: NSLayoutConstraint!
    
    
    var type: DatabaseManager.ConcernType!
    
    var statusPickerView: UIPickerView = UIPickerView()
    var healthConcern : HealthConcern?
    var statusOptions : [DatabaseManager.HealthConcernStatusType] = [.inControl, .notInControl, .resolved]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.customizeTextView(placeholderText:"Note", placeholderColor: UIColor.lightGray, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 8.0)
        statusPickerView.dataSource = self
        statusPickerView.delegate = self
        self.statusTextField.inputView = statusPickerView
        self.scrollView.keyboardDismissMode = .onDrag
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        fillData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    private func fillData() {
        guard let healthConcern = self.healthConcern else {
            deleteButton.isEnabled = false
            createActionPlanViewHeightConstraint.constant = 0
            return
        }
        self.title = healthConcern.title
        titleTextField.text = healthConcern.title
        statusTextField.text = healthConcern.status
        noteTextView.text = healthConcern.note
        createActionPlanViewHeightConstraint.constant = 44
    }

    // SAVE Button
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        if let title = titleTextField.text,
        let status = statusTextField.text,
        let note = noteTextView.text,
            !title.isEmpty, !status.isEmpty {
            if let healthConcern = healthConcern {
                update(healthConern: healthConcern, title: title, status: status, note: note)
                
            } else {
                createNewHealthConcern(title: title, status: status, note: note)
            }
            showSuccessMessage()
        } else{
            let alert = UIAlertController(title: "Required", message: "Please enter the values to save", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    // DELETE Button
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        if let title = titleTextField.text , !title.isEmpty{
            let alert = UIAlertController(title: "Confirm", message: "Do you really want to delete this?", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){UIAlertAction in
                DatabaseManager.shared.deleteHealthConcern(title: title)
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    // CANCEL Button
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addActionPlanTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "createActionPlan", sender: healthConcern)
    }
    
    @IBAction func emptyTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createActionPlan" {
            guard let destinationVC = segue.destination as? AddActionPlanViewController,
                let concern = sender as? HealthConcern else {return}
            destinationVC.healthConcern = concern
        }
    }
    
    
    private func update(healthConern: HealthConcern, title: String, status: String, note: String) {
        healthConern.title = title
        healthConern.status = status
        healthConern.note = note
        DatabaseManager.shared.update(healthConcern: healthConern)
    }
    
    private func createNewHealthConcern(title: String, status: String, note: String) {
        DatabaseManager.shared.addNewHealthConcern(title: title, status: status, note: note, type: type)
    }
    
    private func showSuccessMessage() {
        let alert = UIAlertController(title: "", message: "Saved Successfully", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){UIAlertAction in
            self.navigationController?.popViewController(animated: true)
        })
        self.present(alert, animated: true, completion: nil)
    }
}
// MARK: Picker View
extension AddOrUpdateHealthConcernVC: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statusOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statusOptions[row].stringValue()
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        statusTextField.text = statusOptions[row].stringValue()
    }
}


