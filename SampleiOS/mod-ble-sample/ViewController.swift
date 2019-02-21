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
import mod_ble_swift


class ViewController: UITableViewController, XYSmartScanDelegate, XyoPipeCharacteristicLisitner {
    func onPipe(pipe: XyoNetworkPipe) {
        let handler = XyoNetworkHandler(pipe: pipe)
        
        DispatchQueue.global().async {
            do {
                _ = try self.originChainCreator.doNeogeoationThenBoundWitness(handler: handler, procedureCatalogue: XyoFlagProcedureCatalogue(forOther: 0xff, withOther: 0xff))
            } catch {
                
            }
        }
    }
    
    private var boundWitness : XyoBoundWitness? = nil
    private var canUpdate = true
    private let hasher = XyoSha256()
    private let storageProvider = XyoInMemoryStorage()
    private var blockRepo : XyoStrageProviderOriginBlockRepository
    private var originChainCreator : XyoRelayNode
    private var objects : [XYBluetoothDevice] = []
    private let scanner = XYSmartScan.instance
    private var adv : XyoBluetoothServer!
    
    
    required init?(coder aDecoder: NSCoder) {
        self.blockRepo = XyoStrageProviderOriginBlockRepository(storageProvider: storageProvider, hasher: hasher)
        self.originChainCreator = XyoRelayNode(hasher: hasher, blockRepository: blockRepo)
        originChainCreator.originState.addSigner(signer: XyoStubSigner())
      
        super.init(coder: aDecoder)
        
    }
    
    func smartScan(status: XYSmartScanStatus) {}
    func smartScan(location: XYLocationCoordinate2D) {}
    func smartScan(detected device: XYBluetoothDevice, signalStrength: Int, family: XYDeviceFamily) {}
    func smartScan(entered device: XYBluetoothDevice) {}
    func smartScan(exiting device: XYBluetoothDevice) {}
    func smartScan(exited device: XYBluetoothDevice) {}
    
    func smartScan(detected devices: [XYBluetoothDevice], family: XYDeviceFamily) {
        if (canUpdate) {
            objects = devices
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        self.adv = XyoBluetoothServer()
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        XyoBluetoothDevice.family.enable(enable: true)
        XyoBluetoothDeviceCreator.enable(enable: true)
        
        scanner.start(mode: XYSmartScanMode.foreground)
        scanner.setDelegate(self, key: "main")
        
        originChainCreator.addHuerestic(key: "large", getter: XyoLargeData())
        adv.start(listener: (self as XyoPipeCharacteristicLisitner))
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
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
                
                let indexPath = self.tableView.indexPathForSelectedRow!
                
                upcoming.items.append(ByteListViewController.ByteItem(title: "Bytes", desc: boundWitness?.getBuffer().toByteArray().toHexString() ?? "Error"))
                upcoming.items.append(ByteListViewController.ByteItem(title: "Hash", desc: try boundWitness?.getHash(hasher: XyoSha256()).getBuffer().toByteArray().toHexString() ?? "Error"))
                
                
                
                let numberOfParties = try boundWitness?.getNumberOfParties() ?? 0
                
                for i in 0...numberOfParties - 1 {
                    let fetter = try boundWitness?.getFetterOfParty(partyIndex: i)
                    let witness = try boundWitness?.getWitnessOfParty(partyIndex: i)
                    
                    upcoming.items.append(ByteListViewController.ByteItem(title: "Fetter " + String(i), desc: fetter?.getBuffer().toByteArray().toHexString() ?? "Error"))
                    upcoming.items.append(ByteListViewController.ByteItem(title: "Witness " + String(i), desc: witness?.getBuffer().toByteArray().toHexString() ?? "Error"))
                }
                
                
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
        } catch {}
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.canUpdate = false
        
        //        cell.indicator.startAnimating()
        DispatchQueue.main.async {
            guard let device = self.objects[indexPath.row] as? XyoBluetoothDevice else {
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
                    // cell.indicator.stopAnimating()
                }
                
                DispatchQueue.main.async {
                    // cell.indicator.stopAnimating()
                }
                
            }.always {
                self.canUpdate = true
                XYCentral.instance.disconnect(from: device)
                self.performSegue(withIdentifier: "showView", sender: self)
            }
        }
        
    }
    
}

