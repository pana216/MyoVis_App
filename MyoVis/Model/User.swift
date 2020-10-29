//
//  User.swift
//  MyoVis
//
//  Created by Panagiotis Diakas on 02.08.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//
import Foundation
import Firebase

class User{
    var ref: DatabaseReference = Database.database().reference()
    
    var name:       String
    var age :       Int
    var weight:     Int
    var height:     Int
    var gender:     String
    var timestamp:  Double // timestamp - the moment the user object created, the start button pressed respectively
    var timestampFirebase: String
    
    var signal1 = [String:String]()
    var signal2 = [String:String]()
    var signal3 = [String:String]()
    var signal4 = [String:String]()
    
    // Init
    init(name: String, age: Int, weight: Int, height: Int, gender: String) {
        self.name       = name
        self.age        = age
        self.weight     = weight
        self.height     = height
        self.gender     = gender
        self.timestamp  = NSDate().timeIntervalSince1970 * 1000
        self.timestampFirebase = String(self.timestamp).replace(target: ".", withString: ",")
    }
    
    // MARK: add the signal to an dictionary
    func addSignals(key: String, signal: String, time: String){
        let timestampForFirebase = time.replace(target: ".", withString: ",")
        
        switch key {
            case "signal1":
                signal1[timestampForFirebase] = signal
            case "signal2":
                signal2[timestampForFirebase] = signal
            case "signal3":
                signal3[timestampForFirebase] = signal
            case "signal4":
                signal4[timestampForFirebase] = signal
            default:
                print ("error addKombinatoriResults")
        }// switch
    }
    
    // MARK: push user data one to create the datapath
    func createUserDatapath(){
        let datapath = ref.child("/user/\(self.name)")
        datapath.updateChildValues([
            "age":"\(self.age)",
            "weight":"\(self.weight)",
            "height":"\(self.height)",
            "gender":"\(self.gender)"])
    }
    
    // MARK: push the data to the Server
    // parameters:
    // a) the location e.g. kombinatorik, griffbreite etc - string
    // b) the stage for where the user performed - string
    func pushData(location: String, stage: String){
        let directory = ref.child("user/\(self.name)/measurement/\(self.timestampFirebase)/\(location)/\(stage.removingWhitespaces())")
        directory.child("signal1").setValue(signal1)
        directory.child("signal2").setValue(signal2)
        directory.child("signal3").setValue(signal3)
        directory.child("signal4").setValue(signal4)
    }
    // MARK: push data to DB as Test Run data
    func pushTestRun(){
        let direcotry = ref.child("user/\(self.name)/measurement\(self.timestampFirebase)/testrun")
        direcotry.child("signal1").setValue(signal1)
        direcotry.child("signal2").setValue(signal2)
        direcotry.child("signal3").setValue(signal3)
        direcotry.child("signal4").setValue(signal4)
    }
    
    // MARK: function which emptys the signal dictionaries
    func emptySignalDictionaries(){
        self.signal1 = [:]
        self.signal2 = [:]
        self.signal3 = [:]
        self.signal4 = [:]
    }
    
}
