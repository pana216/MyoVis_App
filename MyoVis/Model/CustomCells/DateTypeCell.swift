//
//  DateTypeCell.swift
//  MyoVis
//
//  Created by Panagiotis Diakas on 24.09.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import UIKit

class DateTypeCell: UITableViewCell {

    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var typeLbl: UILabel!
    
    func setLables(date: String, type: String){
        self.dateLbl.text = date
        self.typeLbl.text = type
    }
}
