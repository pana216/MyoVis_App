//
//  Constants.swift
//  MyoVis
//
//  Created by Panagiotis Diakas on 14.08.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import UIKit
import Foundation
import CoreBluetooth

// CoreBLE
let automationIOServiceUUID = CBUUID(string: "0x1815")
let CHARACTERISTIC_UUID1    = CBUUID(string: "54796c20-40f8-448a-b037-775a705e767a")
let CHARACTERISTIC_UUID2    = CBUUID(string: "ee77813f-a196-46f7-89d8-e736d4e8fc42")
let CHARACTERISTIC_UUID3    = CBUUID(string: "57b89262-1d4d-4892-afc6-f972279ce1c4")
let CHARACTERISTIC_UUID4    = CBUUID(string: "a0b1188c-69bb-4a67-9995-9963f7473377")

// Colors
let lightBlue   = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
let midBlue     = UIColor.init(red: 24/255, green: 58/255, blue: 103/255, alpha: 1)
let darkBlue    = UIColor.init(red: 0/255, green: 31/255, blue: 60/255, alpha: 1)
let appleBlue   = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)

// Notification
let counterNotificationKey = "panagiotis.diakas.MyoVis.counter"
let signalNotificationKey = "panagiotis.diakas.MyoVis.signals"
// Observer
let signalNotificationName = Notification.Name(signalNotificationKey)
let counterNotificationName = Notification.Name(counterNotificationKey)
