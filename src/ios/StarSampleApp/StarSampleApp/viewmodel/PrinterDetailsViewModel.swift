//
//  PrinterDetailsViewModel.swift
//  StarSampleApp
//
//  Created by Bailey Pollard on 2021-11-26.
//

import Foundation
import StarSdk

class PrinterDetailsViewModel: ObservableObject {
    
    private var starManager: StarManager? = nil
    
    @Published
    var printerStatus: String = "Uninitialized"
    
    @Published
    var isPrinting: Bool = false
    
    @Published
    var isConnecting: Bool = false
    
    init(starManager: StarManager) {
        self.starManager = starManager
        
        self.starManager?.printerStatus.collect(collector: Collector<String> { status in
            self.isConnecting = false
            self.printerStatus = status
        }) { (unit, error) in
            // code which is executed if the Flow object completed
        }
        
        self.starManager?.printResult.collect(collector: Collector<Bool> { result in
            self.isPrinting = false
        }) { (unit, error) in
            // code which is executed if the Flow object completed
        }
    }

    func connect(portName: String) {
        isConnecting = true
        starManager?.connect(portName: portName)
    }
    
    func disconnect() {
        starManager?.disconnect()
    }
    
    func print(releasePort: Bool) {
        isPrinting = true
        starManager?.print(releasePort: releasePort)
    }

    func getWifiPrinterStatus(portInfo: PortInfo, timesToReleasePort: Int32) {
        starManager?.getWifiPrinterStatus(portInfo: portInfo, timesToReleasePort: timesToReleasePort)
    }
}
