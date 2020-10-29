//
//  Counter.swift
//  timerTest
//
//  Created by Panagiotis Diakas on 16.08.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import Foundation

class Counter: NSObject{
    var currTime = Date.init()
    var timer = Timer()
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        let now = Date.init()
        let difference = now.timeIntervalSince(currTime)
        
        let ms = Int((difference.truncatingRemainder(dividingBy: 1)) * 100)
        let sec = Int(difference) % 60
        let min = (Int(difference) / 60) % 60
        
        NotificationCenter.default.post(name: counterNotificationName,
                                        object: nil,
                                        userInfo: ["time": "\(min):\(sec):\(ms)"])
    } // updateTimer
    
    func endTimer(){
        timer.invalidate()
    }
}




extension Counter{
    // get current time in date format
    func getCurrentDate()->String{
        let dateFormatter : DateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}

