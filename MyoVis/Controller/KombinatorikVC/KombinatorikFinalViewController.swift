//
//  KombinatorikFinalViewController.swift
//  MyoVis
//
//  Created by Panagiotis Diakas on 22.08.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//
import Foundation
import UIKit
import MessageUI
import Firebase
import FirebaseDatabase

class KombinatorikFinalViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    var central:    CentralManager!
    var peripheral: Peripheral!
    var user:       User!
    var myString = "" // the string where all the user data for the csv file is saved
    var myStages = [Stage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = midBlue
        fetchData()
        // Do any additional setup after loading the view.
        central.disconnect(peripheral: peripheral)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(fetchData), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @objc func fetchData(){
        var time = [String]()
        var date = [String]()
        var signal1 = [String]()
        var signal2 = [String]()
        var signal3 = [String]()
        var signal4 = [String]()
        var counter = 0
        let ref = user.ref
        
        // insert here all user data
        myString.append("user,age,height,weight,gender\n\(user.name),\(user.age),\(user.height),\(user.weight),\(user.gender)\n")
        // get the data from firebase
        ref.child("user/\(user.name)/measurement/\(user.timestampFirebase)/kombinatorik").observeSingleEvent(of: .value, with: {(snapshot) in
            if let stages = snapshot.children.allObjects as? [DataSnapshot]{
                for stage in stages {
                    self.myString.append("\(stage.key)\n") // Stage# 1...9
                    self.myStages.append(Stage(stageName: "\(stage.key)"))
                    // append the csv data structure
                    self.myString.append("time,date,signal1,signal2,signal3,signal4\n")
                    if let signalLevel = stage.value as? [String:Any] {
                        for signal in signalLevel { //SignalX
                            if let entries = signal.value as? [String:String]{
                                let sorted = entries.sorted(by: {$0.key < $1.key}) // sort the arrays by the timestamp
                                for entry in sorted{
                                    switch signal.key {
                                    case "signal1":
                                        // format the timestamp back to a Date
                                        time.append(entry.key.replace(target: ",", withString: "."))
                                        date.append(unixToDate(time: entry.key))
                                        signal1.append(entry.value)
                                        self.myStages[counter].signal1.append(Int(entry.value)!)
                                    case "signal2":
                                        signal2.append(entry.value)
                                        self.myStages[counter].signal2.append(Int(entry.value)!)
                                    case "signal3":
                                        signal3.append(entry.value)
                                        self.myStages[counter].signal3.append(Int(entry.value)!)
                                    case "signal4":
                                        signal4.append(entry.value)
                                        self.myStages[counter].signal4.append(Int(entry.value)!)
                                    default:
                                        print ("Error at fetching Data from DB to device")
                                    }// switch
                                }// for
                            }// entries
                        }// for
                        //write all data into the csv
                        for i in 0..<time.count {
                            self.myString.append("\(time[i]),\(date[i]),\(signal1[i]),\(signal2[i]),\(signal3[i]),\(signal4[i])\n")
                        }
                        // empty all arrays after append the data
                        time = []
                        date = []
                        signal1 = []
                        signal2 = []
                        signal3 = []
                        signal4 = []
                    }// signalLevel
                    counter += 1
                }// for
            }// snapshot
            for stage in self.myStages{
                stage.calculateMedians()
            }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        })// ref
    }
    
    // Export csv
    @IBAction func shareBtnPressed(_ sender: Any) {
        let fileName = "\(user.name).csv"
        let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
            do {
                try myString.write(to: path, atomically: true, encoding: String.Encoding.utf8)
                let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
                vc.excludedActivityTypes = [
                    UIActivity.ActivityType.saveToCameraRoll,
                    UIActivity.ActivityType.openInIBooks
                ]
                present(vc, animated: true, completion: nil)
            } catch  {
                print("error")
                }
        } // shareBtnPressed()
    }


extension KombinatorikFinalViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = lightBlue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myStages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stage = myStages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "KombinatorikCell") as! MedianCell
        cell.setMedianCell(stage: stage.stageName,
                           signal1: String(stage.median1),
                           signal2: String(stage.median2),
                           signal3: String(stage.median3),
                           signal4: String(stage.median4))
        return cell
    }
    
    
}
