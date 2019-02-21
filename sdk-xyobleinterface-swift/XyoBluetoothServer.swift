//
//  XyoAdvertiser.swift
//  mod-ble-swift
//
//  Created by Carter Harrison on 2/18/19.
//

import Foundation
import XyBleSdk
import CoreLocation
import CoreBluetooth
import Promises
import sdk_core_swift
import sdk_objectmodel_swift

/// A class to manage the creating of XYO pipes at a high level on the bluetooth peripheral side.
public struct XyoBluetoothServer {
    
    /// The IBeacon major that will be advertised.
    public let major : UInt16
    
    /// The IBeacon minor that will be advertised.
    public let minor : UInt16
    
    /// The instance of the ble server that will be used to make bluetooth calls, and advertise.
    private let server = XYCBPeripheralManager.instance
    
    /// The mutable service to use for the XYO pipes.
    private let service = XYMutableService(cbService: CBMutableService(type: XYOSerive.pipe.serviceUuid, primary: true))
    
    /// Creates a new instance of this class with a ranom major and a random minor.
    public init () {
        self.major = UInt16.random(in: 0...UInt16.max)
        self.minor = UInt16.random(in: 0...UInt16.max)
    }
    
    /// Creates a new instance of this class with a set major and a set minor.
    public init (major : UInt16, minor: UInt16) {
        self.major = major
        self.minor = minor
    }
    
    /// Starts the bluetooth server, and advertising. Will call back the the provided callback when a pipe has
    /// been created.
    /// - Parameter listener: The callback to call when a pipe has been found, this can be called mutpile times.
    public func start (listener: XyoPipeCharacteristicLisitner) {
        service.addCharacteristic(characteristic: XyoPipeCharacteristic(listener: listener))
        
        server.turnOn().then { (result) in
            if (result) {
                let beacon = CLBeaconRegion(proximityUUID: UUID(uuidString: XYOSerive.pipe.serviceUuid.uuidString)!,
                                            major: self.major,
                                            minor: self.minor,
                                            identifier: "xyo")
                
                self.server.startAdvertiseing(advertisementUUIDs: [CBUUID(string: "1111")], deviceName: "nil", beacon: beacon)
                self.server.addService(service: self.service)
            }
            
        }
    }
    
    /// Turns off the server and advertising
    public func stop () {
        server.stopAdvetrtising()
        server.turnOff()
    }
}
