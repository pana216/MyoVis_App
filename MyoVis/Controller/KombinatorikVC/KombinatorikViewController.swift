//
//  KombinatorikViewController.swift
//  MyoVis
//
//  Created by Panagiotis Diakas on 29.07.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import UIKit
import CoreBluetooth

class KombinatorikViewController: UIViewController, UITextFieldDelegate {
    let central = CentralManager(queue: nil)
    var user:     User?
    
    @IBOutlet var username:         UITextField!
    @IBOutlet var age:              UITextField!
    @IBOutlet var gender:           UISegmentedControl!
    @IBOutlet var height:           UITextField!
    @IBOutlet var weight:           UITextField!
    @IBOutlet var connectionTxt:    UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
        // MARK: handle the Bluetooth state changes
        self.central.stateChange = { [unowned self] state in
            switch state {
            case .unknown:
                print("central.state is .unknown")
            case .resetting:
                print("central.state is .resetting")
            case .unsupported:
                print("central.state is .unsupported")
            case .unauthorized:
                print("central.state is .unauthorized")
            case .poweredOff:
                print("central.state is .poweredOff")
            case .poweredOn:
                print("central.state is .poweredOn")
                self.central.scanForPeripherals(withService: [automationIOServiceUUID])
            @unknown default:
                print("unknown error")
            } // switch
        } // stateChange
        // MARK: handle the connection text based on connection state
        self.central.connectionUpdated = {
            if self.central.connected{
                self.connectionTxt.textColor = UIColor.green
                self.connectionTxt.text = "Connected"
            } else {
                self.connectionTxt.textColor = UIColor.red
                self.connectionTxt.text = "Not Connected"
            }
        }// connectionUpdate
    } // viewDidLoad()
    
    // MARK: hide the keyboard
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    // Mark: if btn pressed and all Text Fields are filled we can continue
    @IBAction func startbtnPressed(_ sender: Any) {
        if !username.text!.isEmpty && !age.text!.isEmpty && !weight.text!.isEmpty && !height.text!.isEmpty && self.central.connected {
            user = User(name:   username.text!,
                        age:    Int(age.text!)!,
                        weight: Int(weight.text!)!,
                        height: Int(height.text!)!,
                        gender: gender.titleForSegment(at: gender.selectedSegmentIndex)!)
            self.user?.createUserDatapath()
            self.performSegue(withIdentifier: "showChartView", sender: self)
        }
    }
    
    // Mark: send the data to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? Stage1ViewController{
            destination.central = central
            destination.peripheral = central.peripherals[0]
            destination.user = user
        }
    }
}

