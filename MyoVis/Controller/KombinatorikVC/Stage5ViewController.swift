//
//  Stage5ViewController.swift
//  MyoVis
//
//  Created by Panagiotis Diakas on 22.08.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import UIKit
import Charts

class Stage5ViewController: UIViewController {

    var counter  =  Counter()
    var central:    CentralManager!
    var peripheral: Peripheral!
    var user:       User?
    var barTitle = ""
    
    @IBOutlet var timerLbl: UILabel!
    @IBOutlet var chartView1: LineChartView!
    @IBOutlet var chartView2: LineChartView!
    @IBOutlet var chartView3: LineChartView!
    @IBOutlet var chartView4: LineChartView!
    // init the arrays where the data is saved
    var data1: [Double] = []
    var data2: [Double] = []
    var data3: [Double] = []
    var data4: [Double] = []
    // the init of the DrawChart Class
    var chart1 = DrawChart()
    var chart2 = DrawChart()
    var chart3 = DrawChart()
    var chart4 = DrawChart()
    // display each individual signal value
    @IBOutlet var signal1Lbl: UILabel!
    @IBOutlet var signal2Lbl: UILabel!
    @IBOutlet var signal3Lbl: UILabel!
    @IBOutlet var signal4Lbl: UILabel!
    @IBOutlet var nextBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        // hide Next Button
        nextBtn.isEnabled = false
        nextBtn.tintColor = UIColor.clear
        // get notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.processSignals(notification:)), name: signalNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCounter(notification:)), name: counterNotificationName, object: nil)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        barTitle = self.navigationItem.title!
        self.peripheral.activateNotifications()
        // start the timer
        counter.startTimer()
        // draw the charts
        chart1.drawChart(chart: &chartView1)
        chart2.drawChart(chart: &chartView2)
        chart3.drawChart(chart: &chartView3)
        chart4.drawChart(chart: &chartView4)
    }
    
    // process the signals
    @objc func processSignals(notification: Notification){
        if let dict = notification.userInfo as? Dictionary<String, String>{
            let time = String(NSDate().timeIntervalSince1970 * 1000)
            for key in dict.keys {
                let value = dict[key]!
                switch key {
                case "signal1":
                    self.user?.addSignals(key: key, signal: value, time: time)
                    signal1Lbl.text = "\(value) mV"
                    self.chart1.updateGraph(View: &chartView1,signal: value)
                    print("\(key) is sending the value: \(value)")
                case "signal2":
                    self.user?.addSignals(key: key, signal: value, time: time)
                    signal2Lbl.text = "\(value) mV"
                    self.chart2.updateGraph(View: &chartView2, signal: value)
                    print("\(key) is sending the value: \(value)")
                case "signal3":
                    self.user?.addSignals(key: key, signal: value, time: time)
                    signal3Lbl.text = "\(value) mV"
                    self.chart3.updateGraph(View: &chartView3, signal: value)
                    print("\(key) is sending the value: \(value)")
                case "signal4":
                    self.user?.addSignals(key: key, signal: value, time: time)
                    signal4Lbl.text = "\(value) mV"
                    self.chart4.updateGraph(View: &chartView4, signal: value)
                    print("\(key) is sending the value: \(value)")
                default:
                    print ("error processSignals")
                }// switch
            } // for
        } // if
    } // processSignals
    
    // MARK: Update the timer
    @objc func updateCounter(notification: Notification){
        if let dict = notification.userInfo as? Dictionary<String, String>{
            if let time = dict["time"] {
                timerLbl.text = time
            }
        }
    }
    
    @IBAction func stopBtnPressed(_ sender: Any) {
        nextBtn.isEnabled = true
        nextBtn.tintColor = appleBlue
        counter.endTimer()
        self.peripheral.disableNotifications()
        self.user?.pushData(location: "kombinatorik", stage: barTitle)
        self.user?.emptySignalDictionaries()
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        // TODO: prepare for segue and send data
        self.performSegue(withIdentifier: "showStage6", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? Stage6ViewController{
            destination.central = central
            destination.peripheral = central.peripherals[0]
            destination.user = user
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
