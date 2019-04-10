//
//  XyoBridgeXDevice.swift
//  sdk-xyobleinterface-swift
//
//  Created by Carter Harrison on 4/9/19.
//

import Foundation
import sdk_objectmodel_swift
import XyBleSdk
import CoreBluetooth

public struct XyoBridgeWifiStatus : Codable {
    public var ip: String
    public var ssid: String
}

class XyoBridgeNetworkStausListener : XYBluetoothDeviceNotifyDelegate {
    var onWifiChangeCallback: ((_: XyoBridgeWifiStatus) -> ())? = nil

    func update(for serviceCharacteristic: XYServiceCharacteristic, value: XYBluetoothResult) {
        print("GOT NOTIFY")
        guard let stringValue = value.data else {
            print("NO STRING")
            return
        }

        do {
            let decoder = JSONDecoder()
            let status = try decoder.decode(XyoBridgeWifiStatus.self, from: stringValue)
            self.onWifiChangeCallback?(status)
        } catch {
            print(String(bytes: stringValue, encoding: String.Encoding.utf8))
            print("ERROR JSON")
        }
    }
}


public class XyoBridgeXDevice : XyoDiffereniableDevice {
    private var delgateKey = ""
    private var hasMutex = false
    private let networkStatusListener = XyoBridgeNetworkStausListener()


    public func onNetworkStatusChange (callback: @escaping (_: XyoBridgeWifiStatus) -> ()) -> Bool {
        let key = "mutex [DBG: \(#function)]: \(Unmanaged.passUnretained(networkStatusListener).toOpaque())"
        let result = self.subscribe(to: XyoBridgeXService.status,
                                    delegate: (key: key, delegate: networkStatusListener))

        networkStatusListener.onWifiChangeCallback = callback

        return result.error == nil
    }

    public func getMutex () -> Bool {
        self.delgateKey = "mutex [DBG: \(#function)]: \(Unmanaged.passUnretained(self).toOpaque())"
        let result = self.subscribe(to: XyoBridgeXService.mutex,
                                    delegate: (key: self.delgateKey, delegate: self))

        if (result.error == nil) {
            hasMutex = true
        }

        return result.error == nil
    }

    public func releaseMutex () -> Bool {
        if (hasMutex) {
            let result = self.unsubscribe(from: XyoBridgeXService.mutex, key: self.delgateKey)

            if (result.error == nil) {
                hasMutex = false
            }

            return result.error == nil
        }

        return false
    }

    public func getSsids () -> [Substring] {
        if (hasMutex) {
            guard let result = self.get(XyoBridgeXService.scan).asString else {
                return []
            }

            return result.split(separator: ",")
        }

        return []
    }
    
    public func isClaimed () -> Bool {
        guard let minor = self.iBeacon?.minor else {
            return false
        }
        
        let flags = XyoBuffer()
            .put(bits: minor)
            .getUInt8(offset: 1)
        
        return flags & 1 != 0
    }
    
    public func isConnected () -> Bool {
        guard let minor = self.iBeacon?.minor else {
            return false
        }
        
        let flags = XyoBuffer()
            .put(bits: minor)
            .getUInt8(offset: 1)
        
        return flags & 2 != 0
    }
    
}
