//
//  TutorialVC.swift
//  MyoVis
//
//  Created by Panagiotis Diakas on 23.09.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import UIKit

class TutorialVC: UIViewController {
    var user: User?
    let central = CentralManager(queue: nil)
    @IBOutlet var connectionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                self.connectionLbl.textColor = UIColor.green
                self.connectionLbl.text = "Connected"
            } else {
                self.connectionLbl.textColor = UIColor.red
                self.connectionLbl.text = "Not Connected"
            }
        }// connectionUpdate
    }
    
    @IBAction func startBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showTestRunVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TestRunVC {
            destination.central = central
            destination.peripheral = central.peripherals[0]
            destination.user = user
        }
    }
}
