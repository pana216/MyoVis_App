//
//  MedianCell.swift
//  MyoVis
//
//  Created by Panagiotis Diakas on 22.09.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import UIKit

class MedianCell: UITableViewCell {
    @IBOutlet var stageLbl: UILabel!
    @IBOutlet var signal1Lbl: UILabel!
    @IBOutlet var signal2Lbl: UILabel!
    @IBOutlet var signal3Lbl: UILabel!
    @IBOutlet var signal4Lbl: UILabel!
    
    func setMedianCell(stage: String, signal1: String, signal2: String, signal3: String, signal4: String){
        self.stageLbl.text = stage
        self.signal1Lbl.text = signal1
        self.signal2Lbl.text = signal2
        self.signal3Lbl.text = signal3
        self.signal4Lbl.text = signal4
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        contentView.backgroundColor = midBlue
    }
}
