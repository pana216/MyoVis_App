//
//  Extensions
//  MyoVis
//
//  Created by Panagiotis Diakas on 15.08.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import Foundation

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}

public func unixToDate(time: String)->String{
    let unix = time.replace(target: ",", withString: ".")
    let date = Date(timeIntervalSince1970: Double(unix)!/1000)
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss:SSS" //Specify your format that you want
    
    return dateFormatter.string(from: date)
}

// sorts an array and calculates the median
public func median(array: Array<Int>)->Double{
    let sortedArray = array.sorted()
    let count = sortedArray.count
    
    if (count % 2) == 0{
        return Double(sortedArray[count/2] + sortedArray[(count/2)-1])/2
    } else {
        return Double(sortedArray[count/2])/2
    }
}

public func median(array: Array<Double>)->Double{
    let sortedArray = array.sorted()
    let count = sortedArray.count
    
    if (count % 2) == 0{
        return Double(sortedArray[count/2] + sortedArray[(count/2)-1])/2
    } else {
        return Double(sortedArray[count/2])/2
    }
}
