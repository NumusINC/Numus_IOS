//
//  NewExpenseViewController.swift
//  Numus
//
//  Created by Arturo Amador Paulino on 11/22/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class NewExpenseViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var categoryTextFiel: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var isIncome: UISwitch!
    
    
    var datePicker: UIDatePicker?
    let categoryPicker = UIDatePicker()
    
    var ref: DatabaseReference!
    
    // Category elements
    let categoryPickerView = UIPickerView()
    let dataPicker = ["PET","Payroll","Groceries","food", "Services", "Taxes", "Healt","Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        datePicker?.minimumDate = Date.init(timeIntervalSinceNow: 0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTaped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        dateTextField.inputView = datePicker
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        dateTextField.inputAccessoryView = toolbar
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        categoryTextFiel.inputView = categoryPickerView
        createPickerView()

    }
    
    @IBAction func saveExpense(_ sender: UIButton) {
        
        //alert()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = dateFormatter.date(from: self.dateTextField.text ?? "")
        
        let timeDate = date?.timeIntervalSince1970
        let category = self.categoryTextFiel.text ?? ""
        let value = self.valueTextField.text ?? ""
        let name = self.nameTextField.text ?? ""
        
        if timeDate == nil || category == "" || value == "" || name == "" {
            alert()
        }else{
            let userID = Auth.auth().currentUser?.uid
            
            let token = Token.init()
            let currentWallet = UserDefaults.standard.string(forKey: "currentWallet")
            
            var income = false
            
            if self.isIncome.isOn{
                income = true
            }
        
            let newExpense = Expense.init(name: name, value: Double(value)!, date: timeDate!, type: category, isIncome: income, token: token.token(), walletKey: currentWallet!)
            newExpense.saveInFireBase()
            
            
            
            
            ref.child("Users/\(userID!)/wallet/\(currentWallet!)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                // Get user value
                let data = snapshot.value
                let walletJson = JSON(data)
                
                let newBudget = walletJson["budget"].double! - newExpense.value
                let wallet = Wallet.init(budget: newBudget,
                                         target: walletJson["target"].double!,
                                         startDate: walletJson["startDate"].double!,
                                         endDate: walletJson["endDate"].double!,
                                         name: walletJson["name"].stringValue,
                                         token: walletJson["token"].stringValue)
                
                wallet.saveInFireBase()
                
                let alert = UIAlertController(title: "Aviso", message: "Expense guardado", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                self.dateTextField.text = ""
                self.categoryTextFiel.text = ""
                self.valueTextField.text = ""
                self.nameTextField.text = ""
                
                
            }) { (error) in
                let alert = UIAlertController(title: "Oops!", message: "Tenemos algunos problemas porfavor intente mas tarde", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print(error.localizedDescription)
            }
            
            
        }
        
    }
    
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        
    }
    
    @objc func viewTaped(gestureRecognizer: UITapGestureRecognizer) {
        //view.endEditing(true)
    }
    
    @objc func donePressed() {
        self.view.endEditing(true)
    }
    
    func alert(){
        let alert = UIAlertController(title: "Alerta", message: "Debes de llenar todos los campos", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func createPickerView() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        //set stiles to textfield
        categoryTextFiel.textAlignment = .center
        categoryTextFiel.inputAccessoryView = toolbar
        categoryTextFiel.inputView = categoryPickerView
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataPicker[row]
    }
    
    // Get the element selected in the Picker View and Put in the text fild (distanceField)
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextFiel.text = dataPicker[row]
    }
    


}
