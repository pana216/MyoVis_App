//
//  ChartVC.swift
//  FirebaseTest
//
//  Created by Panagiotis Diakas on 21.09.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import UIKit
import Charts
import Firebase

class ChartVC: UIViewController {
    @IBOutlet var chartView1: LineChartView!
    @IBOutlet var chartView2: LineChartView!
    @IBOutlet var chartView3: LineChartView!
    @IBOutlet var chartView4: LineChartView!
    
    let ref = Database.database().reference()
    var location = ""
    // init the arrays where the data is saved
    var signal1 = [Double]()
    var signal2 = [Double]()
    var signal3 = [Double]()
    var signal4 = [Double]()
    // the init of the DrawChart Class
    var chart1 = DrawChart()
    var chart2 = DrawChart()
    var chart3 = DrawChart()
    var chart4 = DrawChart()
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = darkBlue
    }
    
    func fetchData(){
        ref.child("\(location)").observeSingleEvent(of: .value, with: {(snapshot) in
            if let signals = snapshot.children.allObjects as? [DataSnapshot] {
                for signal in signals {
                    if let values = signal.value as? [String:String] {
                        for value in values {
                            switch signal.key{
                                case "signal1":
                                    self.signal1.append(Double(value.value)!)
                                case "signal2":
                                    self.signal2.append(Double(value.value)!)
                                case "signal3":
                                    self.signal3.append(Double(value.value)!)
                                case "signal4":
                                    self.signal4.append(Double(value.value)!)
                            default:
                                print("Error in Reading Signal Values")
                            }// switch
                        }
                    }
                }// for
            } // signals
            self.writeDataAsChartDataEntry()
        })// ref
    }

    func writeDataAsChartDataEntry(){
        var counter = 0.0
        for signal in signal1 {
            chart1.chartData.append(ChartDataEntry(x: counter, y: signal))
            chart2.chartData.append(ChartDataEntry(x: counter, y: signal2[Int(counter)]))
            chart3.chartData.append(ChartDataEntry(x: counter, y: signal3[Int(counter)]))
            chart4.chartData.append(ChartDataEntry(x: counter, y: signal4[Int(counter)]))
            counter += 1.0
        }
        chart1.drawChart(chart: &chartView1, data: chart1.chartData)
        chart2.drawChart(chart: &chartView2, data: chart2.chartData)
        chart3.drawChart(chart: &chartView3, data: chart3.chartData)
        chart4.drawChart(chart: &chartView4, data: chart4.chartData)
    }
}
