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
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    var statusPickerView: UIPickerView = UIPickerView()
    var healthConcern : HealthConcern?
    let statusOptions = ["In Control","Not In Control","Resolved"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.customizeTextView(placeholderText: "Note", placeholderColor: UIColor.lightGray, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 8.0)
        statusPickerView.dataSource = self
        statusPickerView.delegate = self
        self.statusTextField.inputView = statusPickerView
        if let  healthConcern = self.healthConcern {
           titleTextField.isUserInteractionEnabled = false
            self.title = healthConcern.title
        }else{
            deleteButton.isEnabled = false
        }
        titleTextField.text = healthConcern?.title
        statusTextField.text = healthConcern?.status
        noteTextView.text = healthConcern?.note
    }

    // SAVE Button
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        if let title = titleTextField.text ,let status = statusTextField.text ,let note = noteTextView.text, !title.isEmpty, !status.isEmpty {
        DatabaseManager.shared.addOrUpdateHealthConcern(title: title, status: status, note: note)
        let alert = UIAlertController(title: "", message: "Saved Successfully", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){UIAlertAction in
                self.navigationController?.popViewController(animated: true)
            })
            self.present(alert, animated: true, completion: nil)
        }else{
            
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
        return statusOptions[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        statusTextField.text = statusOptions[row]
    }
}


