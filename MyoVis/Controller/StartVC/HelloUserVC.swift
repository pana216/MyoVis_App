//
//  HelloUserVC.swift
//  MyoVis
//
//  Created by Panagiotis Diakas on 23.09.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import UIKit

class HelloUserVC: UIViewController {
   @IBOutlet var helloUserLbl: UILabel!
   var user: User?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.helloUserLbl.text = user?.name
    }

    @IBAction func nextBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showPinVC", sender:self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PinVC {
            destination.user = user
        }
    }
}
