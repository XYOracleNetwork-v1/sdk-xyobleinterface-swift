//
//  XYOBluetoothDeviceCreator.swift
//  Pods-SampleiOS
//
//  Created by Carter Harrison on 2/5/19.
//

import Foundation
import XyBleSdk

public struct XyoBluetoothDeviceCreator : XYDeviceCreator {
    private init () {}
    
    public static let uuid : String = XyoBluetoothDevice.uuid
    public var family: XYDeviceFamily = XyoBluetoothDevice.family
    
    
    public func createFromIBeacon (iBeacon: XYIBeaconDefinition, rssi: Int) -> XYBluetoothDevice? {
        return XyoBluetoothDevice(iBeacon: iBeacon, rssi: rssi)
    }
    
    public func createFromId(id: String) -> XYBluetoothDevice {
        return XyoBluetoothDevice(id)
    }
    
    public static func enable (enable : Bool) {
        if (enable) {
            XYBluetoothDeviceFactory.addCreator(uuid: XyoBluetoothDevice.uuid, creator: XyoBluetoothDeviceCreator())
        } else {
            XYBluetoothDeviceFactory.removeCreator(uuid: XyoBluetoothDevice.uuid)
        }
    }
}
