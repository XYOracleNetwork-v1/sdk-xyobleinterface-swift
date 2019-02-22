//
//  XyoService.swift
//  mod-ble-swift
//
//  Created by Carter Harrison on 2/10/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import Foundation
import CoreBluetooth
import XyBleSdk

/// This acts as the primary service for all XYO related things (the pipe abstraction).
public enum XYOSerive : XYServiceCharacteristic {
    /// This is the pipe chararistic where the primary pipe notifactions live.
    case pipe
    
    /// The display name of the service.
    public var serviceDisplayName: String { return "Primary" }
    
    /// The CBUUID of the service.
    public var serviceUuid: CBUUID { return CBUUID(string: "dddddddd-df36-484e-bc98-2d5398c5593e") }
    
    /// The uuid of any characteristic.
    public var characteristicUuid: CBUUID { return CBUUID(string: "727a3639-0eb4-4525-b1bc-7fa456490b2d")}
    
    /// The type of the characteristic.
    public var characteristicType: XYServiceCharacteristicType { return XYServiceCharacteristicType.byte }
    
    /// The display name of the characteristic.
    public var displayName: String { return "XYO" }
    
    /// All characteristic values under the service.
    public static var values: [XYServiceCharacteristic] = [ XYOSerive.pipe ]
    
}
