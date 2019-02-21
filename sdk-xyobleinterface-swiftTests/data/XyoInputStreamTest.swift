//
//  XyoInputStreamTest.swift
//  mod-ble-swiftTests
//
//  Created by Carter Harrison on 2/10/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import XCTest
@testable import mod_ble_swift

class XyoInputStreamTest: XCTestCase {
    
    
    func testInputStreamOne() {
        let stream = XyoInputStream()
        stream.addPacket(packet: [0x00,0x00,0x00,0x06,0x01])
        XCTAssertEqual(nil, stream.getOldestPacket())
        stream.addPacket(packet: [0x02])
        XCTAssertEqual([0x01,0x02], stream.getOldestPacket())
        
        stream.addPacket(packet: [0x00,0x00,0x00,0x06,0x03])
        XCTAssertEqual(nil, stream.getOldestPacket())
        stream.addPacket(packet: [0x04])
        XCTAssertEqual([0x03,0x04], stream.getOldestPacket())
    }
    
    func testInputStreamTwo() {
        let stream = XyoInputStream()
        stream.addPacket(packet: [0x00,0x00,0x00,0x05,0x01])
        XCTAssertEqual([0x01], stream.getOldestPacket())
        
        stream.addPacket(packet: [0x00,0x00,0x00,0x06,0x03])
        XCTAssertEqual(nil, stream.getOldestPacket())
        stream.addPacket(packet: [0x04])
        XCTAssertEqual([0x03,0x04], stream.getOldestPacket())
        
        stream.addPacket(packet: [0x00,0x00,0x00,0x05,0x01])
        XCTAssertEqual([0x01], stream.getOldestPacket())
        
        stream.addPacket(packet: [0x00,0x00,0x00,0x05,0x01])
        XCTAssertEqual([0x01], stream.getOldestPacket())
        
        stream.addPacket(packet: [0x00,0x00,0x00,0x06,0x03])
        XCTAssertEqual(nil, stream.getOldestPacket())
        stream.addPacket(packet: [0x04])
        XCTAssertEqual([0x03,0x04], stream.getOldestPacket())
        
        stream.addPacket(packet: [0x00,0x00,0x00,0x05,0x01])
        XCTAssertEqual([0x01], stream.getOldestPacket())
        
        stream.addPacket(packet: [0x00,0x00,0x00,0x05,0x01])
        XCTAssertEqual([0x01], stream.getOldestPacket())
    }
    
}
