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

public protocol XyoAdvertiserListener {
    func onPipe (pipe: XyoNetworkPipe)
}

public class XyoAdvertiser {
    private let l : XyoAdvertiserListener
    var services = [XYServiceCharacteristic]()
    let server = XYCBPeripheralManager.instance
    private let service = XYMutableService(cbService: CBMutableService(type: XYOSerive.pipe.serviceUuid, primary: true))
    
    public init (l : XyoAdvertiserListener) {
        self.l = l
    }
    
    public func start () {
        service.addCharacteristic(characteristic: XyoPipeCharacteristic(listener: l))
        
        server.turnOn().then { (result) in
            if (result) {
                let beacon = CLBeaconRegion(proximityUUID: UUID(uuidString: XYOSerive.pipe.serviceUuid.uuidString)!,
                                            major: 1,
                                            minor: 1,
                                            identifier: "xyo")
                
                self.server.startAdvertiseing(advertisementUUIDs: [CBUUID(string: "1111")], deviceName: "nil", beacon: beacon)
                self.server.addService(service: self.service)
            }
            
        }
    }
}
