//
//  LabelCell.swift
//  FirebaseTest
//
//  Created by Panagiotis Diakas on 21.09.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import UIKit

class LabelCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    
    func setLbl(label: String){
        self.label.text = label
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        contentView.backgroundColor = midBlue
    }
}
