//
//  NewWalletViewController.swift
//  Numus
//
//  Created by Arturo Amador Paulino on 11/23/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class NewWalletViewController: UIViewController {

    @IBOutlet weak var balanceTextField: UITextField!
    @IBOutlet weak var budgetTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var targetTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    var datePicker: UIDatePicker?
    
    var ref: DatabaseReference!
    
    @objc func viewTaped(gestureRecognizer: UITapGestureRecognizer) {
        //view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        startDateTextField.text = dateFormatter.string(from: datePicker.date)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        datePicker?.minimumDate = Date.init(timeIntervalSinceNow: 0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTaped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        startDateTextField.inputView = datePicker
        
    }

}
