//
//  XyoBluetoothDevice.swift
//  mod-ble-swift
//
//  Created by Carter Harrison on 2/10/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import Foundation
import Promises
import CoreBluetooth
import XyBleSdk
import sdk_core_swift
import sdk_objectmodel_swift

public class XyoBluetoothDevice: XYBluetoothDeviceBase, XYBluetoothDeviceNotifyDelegate, XyoNetworkPipe {
    
    public static let family = XYDeviceFamily.init(uuid: UUID(uuidString: XyoBluetoothDevice.uuid)!,
                                                   prefix: XyoBluetoothDevice.prefix,
                                                   familyName: XyoBluetoothDevice.familyName,
                                                   id: XyoBluetoothDevice.id)
    
    public static let id = "XYO"
    public static let uuid : String = "dddddddd-df36-484e-bc98-2d5398c5593e"
    public static let familyName : String = "XYO"
    public static let prefix : String = "xy:ibeacon"
    private var inputStream = XyoInputStream()
    private var incommingBuffer : [UInt8]? = nil
    private var recivePromise : Promise<[UInt8]?>? = nil
    
    public init(_ id: String, iBeacon: XYIBeaconDefinition? = nil, rssi: Int = XYDeviceProximity.none.rawValue) {
        super.init(id, rssi: rssi, family: XyoBluetoothDevice.family, iBeacon: iBeacon)
    }
    
    public convenience init(iBeacon: XYIBeaconDefinition, rssi: Int = XYDeviceProximity.none.rawValue) {
        self.init(iBeacon.xyId(from: XyoBluetoothDevice.family), iBeacon: iBeacon, rssi: rssi)
    }
    
    public func tryCreatePipe () -> XyoNetworkPipe? {
        self.inputStream = XyoInputStream()
        let result = self.subscribe(to: XYOSerive.read, delegate: (key: "noify", delegate: self))
        if (result.error == nil) {
            return self
        }
        
        return nil
    }
    
    override public func attachPeripheral(_ peripheral: XYPeripheral) -> Bool {
        guard
            self.peripheral == nil,
            let services = peripheral.advertisementData?[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID]
            else { return false }
        
        guard
            services.contains(CBUUID(string: XyoBluetoothDevice.uuid))
            else { return false }
        
        // Set the peripheral and delegate to self
        self.peripheral = peripheral.peripheral
        self.peripheral?.delegate = self
        
        // Save off the services this device was found with for BG monitoring
        self.supportedServices = services
        
        return true
        
    }
    
    public func getInitiationData() -> XyoAdvertisePacket? {
        // this is because we are allways a client
        return nil
    }
    
    public func send(data: [UInt8], waitForResponse: Bool) -> [UInt8]? {
        let sizeEncodedBytes = XyoBuffer()
            .put(bits: UInt32(data.count + 4))
            .put(bytes: data)
            .toByteArray()
        
        let chunks = XyoOutputStream.chunk(bytes: sizeEncodedBytes, maxChunkSize: 20)
        
        for chunk in chunks {
            let status = self.set(XYOSerive.read, value: XYBluetoothResult(data: Data(chunk)), withResponse: true)
            
            if (status.error != nil) {
                return nil
            }
        }
        
        if (waitForResponse) {
            var latestPacket : [UInt8]? = inputStream.getOldestPacket()
            if (latestPacket == nil) {
                recivePromise = Promise<[UInt8]?>.pending()
                do {
                    latestPacket = try await(recivePromise.unsafelyUnwrapped)
                } catch {
                    return nil
                }
            }
            
            return latestPacket
        }
        
        return nil
    }
    
    public func close() {
        disconnect()
    }
    
    public func update(for serviceCharacteristic: XYServiceCharacteristic, value: XYBluetoothResult) {
        if (!value.hasError && value.asByteArray != nil) {
            
            inputStream.addPacket(packet: value.asByteArray!)
            
            guard let donePacket = inputStream.getOldestPacket() else {
                return
            }
            
            recivePromise?.fulfill(donePacket)
        }
    }
}
