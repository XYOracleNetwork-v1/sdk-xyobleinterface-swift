//
//  XYOBluetoothDeviceCreator.swift
//  Pods-SampleiOS
//
//  Created by Carter Harrison on 2/5/19.
//

import Foundation
import XyBleSdk

/// A struct to manage the creation of XYO Devices to create pipes with.
public struct XyoBluetoothDeviceCreator : XYDeviceCreator {
    private init () {}
    
    /// The UUID that should be used when creating an XYO device.
    public static let uuid : String = XyoBluetoothDevice.uuid
    
    /// The device family deffinition.
    public var family: XYDeviceFamily = XyoBluetoothDevice.family
    
    /// A function to create an XYO device from an iBeacon deffinition.
    /// - Parameter iBeacon: The IBeacon deffinion of the device.
    /// - Parameter rssi: The rssi to create the device with.
    public func createFromIBeacon (iBeacon: XYIBeaconDefinition, rssi: Int) -> XYBluetoothDevice? {
        return XyoBluetoothDevice(iBeacon: iBeacon, rssi: rssi)
    }
    
    /// Creae an XyoBluetoothDevice from its repected peripheral ID.
    /// - Parameter id: The peripheral ID of the device.
    public func createFromId(id: String) -> XYBluetoothDevice {
        return XyoBluetoothDevice(id)
    }
    
    /// Enable the creater to be active in XYBluetoothDeviceFactory so that it can be created from bluetooth scan results.
    /// - Parameter enable: If true, will enable. If false, will disbale.
    public static func enable (enable : Bool) {
        if (enable) {
            XYBluetoothDeviceFactory.addCreator(uuid: XyoBluetoothDevice.uuid, creator: XyoBluetoothDeviceCreator())
        } else {
            XYBluetoothDeviceFactory.removeCreator(uuid: XyoBluetoothDevice.uuid)
        }
    }
}
