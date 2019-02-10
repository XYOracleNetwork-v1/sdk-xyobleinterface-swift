//
//  XyoInputStream.swift
//  mod-ble-swift
//
//  Created by Carter Harrison on 2/10/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import Foundation
import sdk_objectmodel_swift

class XyoInputStream {
    private var donePackets = [[UInt8]]()
    private var nextWaitingSize : UInt32?
    private var currentBuffer : XyoBuffer? = nil
    
    func addPacket (packet : [UInt8]) {
        if (currentBuffer == nil && nextWaitingSize == nil) {
            currentBuffer = XyoBuffer(data: packet)
            checkSize()
            checkDone()
            return
        }
        
        currentBuffer.unsafelyUnwrapped.put(bytes: packet)
        checkSize()
        checkDone()
    }
    
    func getOldestPacket () -> [UInt8]? {
        if (donePackets.count > 0) {
            let returnValue = donePackets.first
            donePackets.removeFirst()
            nextWaitingSize = nil
            currentBuffer = nil
            return returnValue
        }
        
        return nil
    }
    
    private func checkSize () {
        if (currentBuffer?.getSize() ?? 0 >= 4) {
            nextWaitingSize = currentBuffer?.getUInt32(offset: 0)
        }
    }
    
    private func checkDone () {
        if (nextWaitingSize ?? 0 <= currentBuffer?.getSize() ?? 4) {
            
            let donePacket = currentBuffer?.copyRangeOf(from: 4, to: (Int(nextWaitingSize ?? 4))).toByteArray() ?? []
            donePackets.append(donePacket)
        }
    }
}
