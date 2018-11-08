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
    let testArray = ["$190","$800.00","$550.78","$678.67","-$67.89"]
    
    let testLabelsArray = ["Ciudad de México","La Habana","Londres","Munich","Washintog DC"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = testArray[indexPath.row]
        
        cell.textLabel?.textColor = UIColor.red
        //cell.detailTextLabel?.text = testLabelsArray[indexPath.row]
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
