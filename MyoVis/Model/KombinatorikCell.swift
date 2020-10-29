//
//  KombinatorikCell.swift
//  MyoVis
//
//  Created by Panagiotis Diakas on 18.09.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import UIKit

class MedianCell: UITableViewCell {

    @IBOutlet var signal1Lbl: UILabel!
    @IBOutlet var signal2Lbl: UILabel!
    @IBOutlet var signal3Lbl: UILabel!
    @IBOutlet var signal4Lbl: UILabel!
    
    func setMedianCell(stage: Stage){
        signal1Lbl.text = String(stage.median1)
        signal2Lbl.text = String(stage.median2)
        signal3Lbl.text = String(stage.median3)
        signal4Lbl.text = String(stage.median4)
    }

}
