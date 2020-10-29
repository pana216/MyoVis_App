//
//  Stage.swift
//  MyoVis
//
//  Created by Panagiotis Diakas on 18.09.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import Foundation

class Stage {
    var stageName: String
    var median1 = 0.0
    var median2 = 0.0
    var median3 = 0.0
    var median4 = 0.0
    var stageMedian = 0.0
    
    var signal1 = [Int]()
    var signal2 = [Int]()
    var signal3 = [Int]()
    var signal4 = [Int]()
    
    init(stageName: String) {
        self.stageName = stageName
    }
    
    func calculateMedians(){
        median1 = median(array: signal1)
        median2 = median(array: signal2)
        median3 = median(array: signal3)
        median4 = median(array: signal4)
    }
    
    func calculateMedian(){
        let arr = [self.median1, self.median2, self.median3, self.median4]
        self.stageMedian = median(array: arr)
    }
}
