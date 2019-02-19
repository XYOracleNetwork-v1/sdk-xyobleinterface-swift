//
//  XyoCharManager.swift
//  mod-ble-swift
//
//  Created by Carter Harrison on 2/19/19.
//

import Foundation
import CoreBluetooth
import sdk_core_swift
import sdk_objectmodel_swift
import Promises


class XyoCharManager : XyoNetworkPipe {
    var readPromise = Promise<[UInt8]?>.pending()
    let inputStream = XyoInputStream()
    
    let centrel : CBCentral
    let char : CBMutableCharacteristic
    let peripheral : CBPeripheralManager
    let initiationData : XyoAdvertisePacket
    let listener : XyoCharManagerListener
    
    init (initiationData : XyoAdvertisePacket,
          peripheral : CBPeripheralManager,
          centrel : CBCentral,
          char: CBMutableCharacteristic,
          listener: XyoCharManagerListener) {
        
        self.initiationData = initiationData
        self.peripheral = peripheral
        self.centrel = centrel
        self.char = char
        self.listener = listener
    }
    
    func getInitiationData() -> XyoAdvertisePacket? {
        return initiationData
    }
    
    func send(data: [UInt8], waitForResponse: Bool) -> [UInt8]? {
        chunkSend(data: data)
        
        if (waitForResponse) {
            let currentPacet = inputStream.getOldestPacket()
            if (currentPacet != nil) {
                return currentPacet
            }
            
            readPromise = Promise<[UInt8]?>.pending()
            
            do {
                return try await(readPromise)
            } catch {
                return nil
            }
        }
        
        return nil
    }
    
    func close() {
        listener.onClose(device: centrel)
    }
    
    private func chunkSend (data : [UInt8]) {
        let sizeEncoded = XyoBuffer()
            .put(bits: UInt32(data.count + 4))
            .put(bytes: data)
            .toByteArray()
        let chunks = XyoOutputStream.chunk(bytes: sizeEncoded, maxChunkSize: centrel.maximumUpdateValueLength - 3)
        
        for chunk in chunks {
            char.value = Data(chunk)
            peripheral.updateValue(Data(chunk), for: char, onSubscribedCentrals: nil)
        }
    }
    
    func handleWriteRequest(_ request: CBATTRequest, peripheral: CBPeripheralManager) {
        let value : [UInt8] = [UInt8](request.value ?? Data())
        
        inputStream.addPacket(packet: value)
        peripheral.respond(to: request, withResult: .success)
        
        let newPacket = inputStream.getOldestPacket()
        
        if (newPacket != nil) {
            readPromise.fulfill(newPacket)
        }
    }
    
}

protocol XyoCharManagerListener {
    func onClose (device : CBCentral)
}

