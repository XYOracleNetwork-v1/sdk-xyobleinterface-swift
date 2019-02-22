//
//  ViewController.swift
//  mod-ble-swift
//
//  Created by Carter Harrison on 1/31/19.
//  Copyright © 2019 XYO Network. All rights reserved.
//

import UIKit
import CoreBluetooth
import XyBleSdk
import sdk_core_swift
import sdk_xyobleinterface_swift


/// The primary view controller that maintains the list of device and handles bound witnesses.
/// This view is used as a test app for doung bound witnesses with other XYO BLE enabled devices.
class ViewController: UITableViewController, XYSmartScanDelegate, XyoPipeCharacteristicLisitner {
    /// The current bound witness that is shown after a bound witness is done
    private var boundWitness : XyoBoundWitness? = nil
    
    /// If the table view can show more devices, this is set to false when a user chooses to connect to a device.
    private var canUpdate = true
    
    /// The hasher to create bound witnesses with, (previous hashes)
    private let hasher = XyoSha256()
    
    /// The place to store all of the origin blocks after they are created, this will be cleared after the view is recreated
    private let storageProvider = XyoInMemoryStorage()
    
    /// The interface for talking to the storageProvider to store orgin blocks.
    private var blockRepo : XyoStrageProviderOriginBlockRepository
    
    /// The node that handles all of the bound witnessing.
    private var originChainCreator : XyoRelayNode
    
    /// All of the current nearby devices to do bound witnesses with, this is the data in the listview.
    private var devices : [XYBluetoothDevice] = []
    
    /// The scanner to scan for XYO devices
    private let scanner = XYSmartScan.instance
    
    /// The server to let other devices to connect to do bound witnesses.
    private var server : XyoBluetoothServer!
    
    /// The initer to init all of the XYO related objects.
    required init?(coder aDecoder: NSCoder) {
        self.blockRepo = XyoStrageProviderOriginBlockRepository(storageProvider: storageProvider, hasher: hasher)
        self.originChainCreator = XyoRelayNode(hasher: hasher, blockRepository: blockRepo)
        originChainCreator.originState.addSigner(signer: XyoStubSigner())
        
        super.init(coder: aDecoder)
    }
    
    /// This is called when the view loads, and enables the table view and starts the bluetooth
    override func viewDidLoad() {
        self.server = XyoBluetoothServer()
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        XyoBluetoothDevice.family.enable(enable: true)
        XyoBluetoothDeviceCreator.enable(enable: true)
        
        scanner.start(mode: XYSmartScanMode.foreground)
        scanner.setDelegate(self, key: "main")
        
        originChainCreator.addHuerestic(key: "large", getter: XyoLargeData(numberOfBytes: 1000))
        server.start(listener: (self as XyoPipeCharacteristicLisitner))
        
    }
    
    /// This function is called whenever a pipe is made from the BLE server
    func onPipe(pipe: XyoNetworkPipe) {
        let handler = XyoNetworkHandler(pipe: pipe)
        
        DispatchQueue.global().async {
            do {
                self.boundWitness = try self.originChainCreator.doNeogeoationThenBoundWitness(handler: handler, procedureCatalogue: XyoFlagProcedureCatalogue(forOther: 0xff, withOther: 0xff))
                
                if (self.boundWitness != nil) {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "showView", sender: self)
                    }
                }
                
            } catch {}
        }
    }
    
    
    /// This is the function that notifies us of the devices nearby
    func smartScan(detected devices: [XYBluetoothDevice], family: XYDeviceFamily) {
        if (canUpdate) {
            self.devices = devices
            tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath as IndexPath) as! TableViewCellController
        cell.title.text = "XYO"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "XYO Devices"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        do {
            if (segue.identifier == "showView") {
                let upcoming: ByteListViewController = segue.destination as! ByteListViewController
                
                upcoming.items.append(ByteListViewController.ByteItem(title: "Bytes", desc: boundWitness?.getBuffer().toByteArray().toHexString() ?? "Error"))
                upcoming.items.append(ByteListViewController.ByteItem(title: "Hash", desc: try boundWitness?.getHash(hasher: XyoSha256()).getBuffer().toByteArray().toHexString() ?? "Error"))
                
                
                let numberOfParties = try boundWitness?.getNumberOfParties() ?? 0
                
                for i in 0...numberOfParties - 1 {
                    let fetter = try boundWitness?.getFetterOfParty(partyIndex: i)
                    let witness = try boundWitness?.getWitnessOfParty(partyIndex: i)
                    
                    upcoming.items.append(ByteListViewController.ByteItem(title: "Fetter " + String(i), desc: fetter?.getBuffer().toByteArray().toHexString() ?? "Error"))
                    upcoming.items.append(ByteListViewController.ByteItem(title: "Witness " + String(i), desc: witness?.getBuffer().toByteArray().toHexString() ?? "Error"))
                }
                
                deselectRow()
            }
        } catch {}
        
    }
    
    private func deselectRow () {
        DispatchQueue.main.async {
            let indexPath = self.tableView.indexPathForSelectedRow
            if (indexPath != nil) {
                self.tableView.deselectRow(at: indexPath!, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.canUpdate = false
        
        DispatchQueue.main.async {
            guard let device = self.devices[indexPath.row] as? XyoBluetoothDevice else {
                return
            }
            
            device.connection {
                do {
                    guard let pipe = device.tryCreatePipe() else {
                        return
                    }
                    
                    let handler = XyoNetworkHandler(pipe: pipe)
                    
                    self.boundWitness = try self.originChainCreator.doNeogeoationThenBoundWitness(handler: handler, procedureCatalogue: XyoFlagProcedureCatalogue(forOther: 0xff, withOther: 0xff))
                    
                } catch {
                    self.canUpdate = true
                    XYCentral.instance.disconnect(from: device)
                    return
                }
                
            }.always {
                self.canUpdate = true
                XYCentral.instance.disconnect(from: device)
                self.performSegue(withIdentifier: "showView", sender: self)
            }
        }
        
    }
    
    
    func smartScan(status: XYSmartScanStatus) {}
    func smartScan(location: XYLocationCoordinate2D) {}
    func smartScan(detected device: XYBluetoothDevice, signalStrength: Int, family: XYDeviceFamily) {}
    func smartScan(entered device: XYBluetoothDevice) {}
    func smartScan(exiting device: XYBluetoothDevice) {}
    func smartScan(exited device: XYBluetoothDevice) {}
}

