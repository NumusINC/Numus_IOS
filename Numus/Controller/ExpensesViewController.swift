//
//  ExpensesViewController.swift
//  Numus
//
//  Created by Arturo Amador Paulino on 10/31/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import Charts

class ExpensesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    var ref: DatabaseReference!
    var objectArray = [Expense]()
    
    var chart = PieChartDataEntry(value:0)
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var pieChart: PieChartView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let idx = indexPath.row
        
        cell.textLabel?.text = objectArray[idx].name
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.red
        if objectArray[idx].isIncome {
            cell.detailTextLabel?.textColor = UIColor.green
        }
        cell.detailTextLabel?.text = "$ \(String(format: "%.1f", objectArray[idx].value))0"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let expense = self.objectArray[indexPath.row]
            expense.delete()
            self.objectArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func updateChart() {
        let chartDataSet = PieChartDataSet(values: numberOfDownloadsDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        
        // Get all the expenses
        let userID = Auth.auth().currentUser!.uid
        self.objectArray.removeAll()
        ref.child("Users/\(userID)/expense").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let data = snapshot.value as? NSDictionary
            
            //avoid null
            if data == nil{
                return
            }
            
            for idx in data! {
                let json = JSON(idx.value)
                let expense = Expense.init(name: json["name"].stringValue,
                                           value: json["value"].double!,
                                           date: json["date"].double!,
                                           type: json["type"].stringValue,
                                           isIncome: json["isIncome"].bool!,
                                           token: json["token"].stringValue,
                                           walletKey: json["walletKey"].stringValue)
                
                self.objectArray.append(expense)
                self.table.reloadData()
                
                //numberOfDownloadsDataEntries.append(expense.type)
                
            }
            
        }) { (error) in
            let alert = UIAlertController(title: "Oops!", message: "Tenemos algunos problemas porfavor intente mas tarde", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print(error.localizedDescription)
        }
        
    }
    
}
