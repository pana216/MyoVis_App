//
//  StartStage4VC.swift
//  MyoVis
//
//  Created by Panagiotis Diakas on 23.09.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import UIKit

class StartStage4VC: UIViewController {
    var central:    CentralManager!
    var peripheral: Peripheral!
    var user:       User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showStage4VC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? Stage4VC {
            destination.user = user
            destination.central = central
            destination.peripheral = peripheral
        }
    }
    
}
