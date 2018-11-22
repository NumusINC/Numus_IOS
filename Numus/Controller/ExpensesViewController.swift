//
//  ExpensesViewController.swift
//  Numus
//
//  Created by Arturo Amador Paulino on 10/31/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit
import Firebase

class ExpensesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    var ref: DatabaseReference!
    //ref = Database.database().reference()
    var testArray = ["$190","$800.00","$550.78","$678.67","-$67.89"]
    
    var testLabelsArray = ["Ciudad de México","La Habana","Londres","Munich","Washintog DC"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = testArray[indexPath.row]
        cell.textLabel?.textColor = UIColor.red
        cell.detailTextLabel?.text = testLabelsArray[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            self.testArray.remove(at: indexPath.row)
            self.testLabelsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
