//
//  CoreBLE.swift
//  MyoVis
//
//  Created by Panagiotis Diakas on 14.08.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//
import Foundation
import CoreBluetooth


public class CentralManager: NSObject, CBCentralManagerDelegate {
    
    private let manager: CBCentralManager!
    public var peripherals: [Peripheral] = []
    public var stateChange: ((CBManagerState) -> Void)? = nil
    public var connectionUpdated: (() -> Void)? = nil
    
    public var connected: Bool = false {
        didSet{
            connectionUpdated?()
        }
    }
    
    public init(queue: DispatchQueue? = nil) {
        manager = CBCentralManager(delegate: nil, queue: queue)
        
        super.init()
        manager.delegate = self
    }
    
    public func scanForPeripherals(withService services: [CBUUID]?){
        manager.scanForPeripherals(withServices: services, options: nil)
    }
    
    public func connect(peripheral: Peripheral){
        manager.connect(peripheral.peripheral, options: nil)
    }
    
    public func disconnect(peripheral: Peripheral) {
        manager.cancelPeripheralConnection(peripheral.peripheral)
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripherals[0].discoverServices()
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        //TODO: do something if the peripheral disonnects
        print("Connection Lost")
        connected = false
        scanForPeripherals(withService: [automationIOServiceUUID])
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        stateChange?(central.state)
        
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,advertisementData: [String : Any], rssi RSSI: NSNumber) {
        peripherals.append(Peripheral(peripheral: peripheral, advertisementData: advertisementData, RSSI: RSSI.intValue))
        //peripheral.delegate = self
        manager.stopScan()
        manager.connect(peripheral)
        connected = true
    }
}

public class Peripheral: NSObject, CBPeripheralDelegate {
    
    let peripheral: CBPeripheral
    let advertisementData: [String: Any]
    let RSSI: Int
    
    public var servicess = [CBService]()
    public var myCharacteristics = [CBCharacteristic]()
    var counter = 0
    
    init(
        peripheral: CBPeripheral,
        advertisementData: [String: Any],
        RSSI: Int
        ) {
        self.peripheral = peripheral
        self.advertisementData = advertisementData
        self.RSSI = RSSI
        super.init()
        peripheral.delegate = self
    }
    
    deinit {
        print("deinit Peripheral in CoreBLE")
    }
    
    func connectState() -> CBPeripheralState {
        return peripheral.state
    }
    
    func discoverServices(){
        peripheral.discoverServices(nil)
    }
    
    func discoverCharacterisics(){
        peripheral.discoverCharacteristics(nil, for: servicess[0])
    }
    
    func disableNotifications(){
        for characteristic in myCharacteristics{
            peripheral.setNotifyValue(false, for: characteristic)
        }
    }
    
    func activateNotifications(){
        for characteristic in myCharacteristics{
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services{
            servicess.append(service)
            print("Service is: " + "\(service)")
            //peripheral.discoverCharacteristics(nil, for: service)
            //setNotificationTrue(service: service)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {return}
        
        for characteristic in characteristics {
            // check if characteristic advertises .read or .notify
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
//                myCharacteristics.append(characteristic)
//                peripheral.readValue(for: characteristic)
            }
            // if characteristic implements "notify"
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                // append the charactersitic to the characteristics array
                myCharacteristics.append(characteristic)
                // enable to get notify if value changes
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }// for
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        // get the signal values
        let result = getByteArray(from: characteristic)
        print(counter += 1)
        // Notify:
        NotificationCenter.default.post(name: signalNotificationName, object: nil, userInfo:
            ["signal1":"\(result.signal1)",
            "signal2":"\(result.signal2)",
            "signal3":"\(result.signal3)",
            "signal4":"\(result.signal4)"])
//        NotificationCenter.default.post(name: signalNotificationName, object: nil, userInfo: ["signal2":"\(result.signal2)"])
//        NotificationCenter.default.post(name: signalNotificationName, object: nil, userInfo: ["signal3":"\(result.signal3)"])
//        NotificationCenter.default.post(name: signalNotificationName, object: nil, userInfo: ["signal4":"\(result.signal4)"])
        
    }
    
    private func getByteArray(from characteristic: CBCharacteristic) -> (signal1: Int, signal2: Int, signal3: Int, signal4: Int) {
        guard let characteristicData = characteristic.value else {return (-1,-1,-1,-1)}
        let byteArray = [UInt8](characteristicData)
        
        let signal1 = Int(byteArray[0])<<0
            + Int(byteArray[1])<<8
            + Int(byteArray[2])<<16
            + Int(byteArray[3])<<24
        let signal2 = Int(byteArray[4])<<0
            + Int(byteArray[5])<<8
            + Int(byteArray[6])<<16
            + Int(byteArray[7])<<24
        let signal3 = Int(byteArray[8])<<0
            + Int(byteArray[9])<<8
            + Int(byteArray[10])<<16
            + Int(byteArray[11])<<24
        let signal4 = Int(byteArray[12])<<0
            + Int(byteArray[13])<<8
            + Int(byteArray[14])<<16
            + Int(byteArray[15])<<24
        
        return (signal1, signal2, signal3, signal4)
    }
}
