//
//  XyoChar.swift
//  mod-ble-swift
//
//  Created by Carter Harrison on 2/19/19.
//

import Foundation
import CoreBluetooth
import XyBleSdk
import sdk_objectmodel_swift
import sdk_core_swift

class XyoChar : XYMutableCharacteristic, XyoCharManagerListener {
    
    var cbCharacteristic: CBMutableCharacteristic = CBMutableCharacteristic(type: XYOSerive.read.characteristicUuid,
                                                                            properties: CBCharacteristicProperties(rawValue: CBCharacteristicProperties.read.rawValue |
                                                                                CBCharacteristicProperties.notify.rawValue |
                                                                                CBCharacteristicProperties.indicate.rawValue |
                                                                                CBCharacteristicProperties.write.rawValue),
                                                                            value: nil,
                                                                            permissions: CBAttributePermissions(rawValue: CBAttributePermissions.readable.rawValue | CBAttributePermissions.writeable.rawValue)
    )
    
    var managers = [String : XyoCharManager] ()
    private let listener : XyoAdvertiserListener
    
    init (listener : XyoAdvertiserListener) {
        self.listener = listener
    }
    
    func handleReadRequest(_ request: CBATTRequest, peripheral: CBPeripheralManager) {}
    
    func handleWriteRequest(_ request: CBATTRequest, peripheral: CBPeripheralManager) {
        guard let manager = managers[request.central.identifier.uuidString] else {
            peripheral.respond(to: request, withResult: .success)
            let value : [UInt8] = [UInt8](request.value ?? Data())
            if (value.count > 4) {
                let buffer = XyoBuffer(data: value)
                let sizeOfCat = buffer.getUInt8(offset: 4)
                
                if (sizeOfCat != value.count - 5) {
                    return
                }
                
                let catData = buffer.copyRangeOf(from: 4, to: buffer.getSize())
                let advPacket = XyoAdvertisePacket(data: catData.toByteArray())
                let pipe = XyoCharManager(initiationData: advPacket,
                                          peripheral: peripheral,
                                          centrel: request.central,
                                          char: cbCharacteristic,
                                          listener: self)
                
                
                managers[request.central.identifier.uuidString] = pipe
                listener.onPipe(pipe: pipe)
            }
            
            return
        }
        
        manager.handleWriteRequest(request, peripheral: peripheral)
    }
    
    func onClose(device : CBCentral) {
        managers.removeValue(forKey: device.identifier.uuidString)
    }
    
    func handleSubscribeToCharacteristic(peripheral: CBPeripheralManager) {}
}

