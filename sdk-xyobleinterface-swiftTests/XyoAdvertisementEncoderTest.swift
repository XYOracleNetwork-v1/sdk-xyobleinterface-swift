//
//  XyoAdvertisementEncoderTest.swift
//  sdk-xyobleinterface-swiftTests
//
//  Created by Carter Harrison on 4/2/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import XCTest
@testable import sdk_xyobleinterface_swift

class XyoInputStreamTest2: XCTestCase {

    func testCaseOne () {
        let id: UInt8 = 0x01
        let randomSeed: UInt32 = 0b1111_1111_1111_1111_1111_1111_1111_1111
        let expected: UInt16 = 0b1111_1111_1100_0001
        let major = XyoBluetoothServer.getMajor(randomSeed: randomSeed, id: id)
        
        XCTAssertEqual(major, expected)
    }
    
    func testCaseTwo () {
        let id: UInt8 = 0x00
        let randomSeed: UInt32 = 0b1111_1111_1111_1111_1111_1111_1111_1111
        let expected: UInt16 = 0b1111_1111_1100_0000
        let major = XyoBluetoothServer.getMajor(randomSeed: randomSeed, id: id)
        
        XCTAssertEqual(major, expected)
    }
    
    func testCaseThree () {
        let id: UInt8 = 0xff
        let randomSeed: UInt32 = 0
        let expected: UInt16 = 0b0000_0000_0011_1111
        let major = XyoBluetoothServer.getMajor(randomSeed: randomSeed, id: id)
        
        XCTAssertEqual(major, expected)
    }
}
