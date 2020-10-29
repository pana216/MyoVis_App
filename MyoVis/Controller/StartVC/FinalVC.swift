//
//  FinalVC.swift
//  MyoVis
//
//  Created by Panagiotis Diakas on 23.09.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import UIKit
import Firebase

class FinalVC: UIViewController {
    @IBOutlet var testRunText: UITextView!
    @IBOutlet var bestStageText: UITextView!
    @IBOutlet var relationText: UITextView!
    
    var central:    CentralManager!
    var peripheral: Peripheral!
    var user:       User?
    let ref = Database.database().reference()
    var myStages = [Stage]()
    var testRun: Stage? {
        didSet {
            self.testRunText.text.append("\(self.testRun!.stageMedian) mV \n")
        }
    }
    var bestStage: Stage? {
        didSet{
            self.bestStageText.text.append(self.getBestStageText())
            self.relationText.text.append(self.calculateRelation())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTestRun()
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        central.disconnect(peripheral: peripheral)
    
    }
    
    func getBestStageText()->String{
        let name = self.bestStage?.stageName
        switch name{
        case "Stage1":
            return "\(self.bestStage!.stageName) mit \n Griffbreite: Breit \nAblagepunkt: Unterhalb\n"
        case "Stage2":
            return "\(self.bestStage!.stageName) mit \n Griffbreite: Breit \nAblagepunkt: Mitte\n"
        case "Stage3":
            return "\(self.bestStage!.stageName) mit \n Griffbreite: Breit \nAblagepunkt: Oberhalb\n"
        case "Stage4":
            return "\(self.bestStage!.stageName) mit \n Griffbreite: Mittig \nAblagepunkt: Unterhalb\n"
        case "Stage5":
            return "\(self.bestStage!.stageName) mit \n Griffbreite: Mittig \nAblagepunkt: Mitte\n"
        case "Stage6":
            return "\(self.bestStage!.stageName) mit \n Griffbreite: Mittig \nAblagepunkt: Oberhalb\n"
        case "Stage7":
            return "\(self.bestStage!.stageName) mit \n Griffbreite: Eng\nAblagepunkt: Unterhalb\n"
        case "Stage8":
            return "\(self.bestStage!.stageName) mit \n Griffbreite: Eng\nAblagepunkt: Mitte\n"
        case "Stage9":
            return "\(self.bestStage!.stageName) mit \n Griffbreite: Eng\nAblagepunkt: Oberhalb\n"
        default:
            print("No Best stage to return")
            return "Error"
        }
    }
    
    func calculateRelation()->String{
        let diff = (Double(self.bestStage!.stageMedian)/Double(self.testRun!.stageMedian))*100
        return "\(Double(round(diff)*1000)/1000)%"
    }
    
    func compareStages(test: Stage, best: Stage)->(name: String, value: String){
        if test.stageMedian > best.stageMedian {
            return (test.stageName, String(test.stageMedian))
        } else {
            return (best.stageName, String(best.stageMedian))
        }
    }
    
    func fetchTestRun(){
        let location = "user/\(user!.name)/measurement/\(user!.timestampFirebase)/testrun/"
        ref.child(location).observeSingleEvent(of: .value, with: {(snapshot) in
            if let signals = snapshot.children.allObjects as? [DataSnapshot] {
                self.testRun = Stage(stageName: "testrun")
                for signal in signals {
                    if let entries = signal.value as? [String:String] {
                        for entry in entries {
                            switch signal.key {
                            case "signal1":
                                self.testRun?.signal1.append(Int(entry.value)!)
                            case "signal2":
                                self.testRun?.signal2.append(Int(entry.value)!)
                            case "signal3":
                                self.testRun?.signal3.append(Int(entry.value)!)
                            case "signal4":
                                self.testRun?.signal4.append(Int(entry.value)!)
                            default:
                                print("Error fetching data!")
                            }// switch
                        }
                    }
                }
            }
            self.testRun?.calculateMedians()
            self.testRun?.calculateMedian()
        })// ref
    }
    
    func fetchData(){
        var counter = 0
        let location = "user/\(user!.name)/measurement/\(user!.timestampFirebase)/main/"
        ref.child("\(location)").observeSingleEvent(of: .value, with: {(snapshot) in
            if let stages = snapshot.children.allObjects as? [DataSnapshot] {
                self.myStages = []
                for stage in stages {
                    self.myStages.append(Stage(stageName: stage.key))
                    if let signals = stage.value as? [String:Any] {
                        for signal in signals {
                            if let entries = signal.value as? [String:String]{
                                for entry in entries {
                                    switch signal.key{
                                    case "signal1":
                                        self.myStages[counter].signal1.append(Int(entry.value)!)
                                    case "signal2":
                                        self.myStages[counter].signal2.append(Int(entry.value)!)
                                    case "signal3":
                                        self.myStages[counter].signal3.append(Int(entry.value)!)
                                    case "signal4":
                                        self.myStages[counter].signal4.append(Int(entry.value)!)
                                    default:
                                        print("Error fetching data!")
                                    }// switch
                                }// for entry
                            }// if entries
                        }// for signal
                    }// if stages
                    counter += 1
                }// for stage
            }
            for stage in self.myStages {
                stage.calculateMedians()
                stage.calculateMedian()
            }
            self.bestStage = self.getBestStage()
        })// ref
    }// fetchData
    
    func getBestStage()->Stage{
        let bestStage = myStages.max(by: {(a,b) -> Bool in
            return a.stageMedian < b.stageMedian
        })
        
        return bestStage!
    }
}
