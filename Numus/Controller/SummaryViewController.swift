//
//  SummaryViewController.swift
//  Numus
//
//  Created by Antonio Rangel & Andrés Andaluz  on 11/16/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit
import Charts

class SummaryViewController: UIViewController {

    @IBOutlet weak var pieChart: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let dataEntryTest = [190.01, 800.00, 550.78, 678.67, 67.89, 675.90, 543.89]
        let testLabelsArray = ["PET","FOOD","TAXES","HEALTH","PAYROLL","SERVICES","GROCERIES"]
        let percentages = percentage(arr: dataEntryTest)
        setChart(dataPoints: testLabelsArray, values: percentages)
    }
    
    func percentage(arr: [Double]) -> [Double] {
        var res = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
        var sum = 0.0
        
        for i in 0..<arr.count {
            sum += arr[i]
        }
        
        for i in 0..<arr.count {
            let temp = (arr[i] * 100) / sum
            res[i] = temp
        }
        
        return res
    }
    
    func setChart(dataPoints: [String], values: [Double]){
        var dataEntries: [PieChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
        pieChartDataSet.colors = colors
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        
        pieChart.data = pieChartData
        pieChart.animate(xAxisDuration: 2.0)
        pieChart.holeColor = .gray
        pieChart.drawEntryLabelsEnabled = false
        pieChart.legend.textColor = .white
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
