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

public enum XYOSerive : XYServiceCharacteristic {
    case read
    
    public var serviceDisplayName: String { return "Primary" }
    
    public var serviceUuid: CBUUID { return CBUUID(string: "dddddddd-df36-484e-bc98-2d5398c5593e") }
    
    public var characteristicUuid: CBUUID { return CBUUID(string: "727a3639-0eb4-4525-b1bc-7fa456490b2d")}
    
    public var characteristicType: XYServiceCharacteristicType { return XYServiceCharacteristicType.byte }
    
    public var displayName: String { return "XYO" }
    
    public static var values: [XYServiceCharacteristic] = [ XYOSerive.read ]
    
}
