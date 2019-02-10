//
//  XyoOutputStream.swift
//  mod-ble-swift
//
//  Created by Carter Harrison on 2/10/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import Foundation

struct XyoOutputStream {
    static func chunk (bytes : [UInt8], maxChunkSize : Int) -> [[UInt8]] {
        var chunks = [[UInt8]]()
        var currentChunk = [UInt8]()
        
        for i in 0...bytes.count - 1 {
            currentChunk.append(bytes[i])
            
            if (currentChunk.count == maxChunkSize || i == bytes.count - 1) {
                chunks.append(currentChunk)
                currentChunk = [UInt8]()
            }
        }
        
        
        return chunks
    }
}
