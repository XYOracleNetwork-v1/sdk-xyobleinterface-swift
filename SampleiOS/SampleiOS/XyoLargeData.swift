//
//  XyoLargeData.swift
//  mod-ble-sample
//
//  Created by Carter Harrison on 2/20/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import Foundation
import sdk_core_swift
import sdk_objectmodel_swift

class XyoLargeData : XyoHueresticGetter {
    func getHeuristic() -> XyoObjectStructure? {
        var bytes = [UInt8]()
        
        for i in 0...1000 {
            bytes.append(UInt8(0))
        }
        
        
        return XyoObjectStructure.newInstance(schema: XyoSchemas.BLOB, bytes: XyoBuffer.init(data: bytes))
    }
    
    
}
