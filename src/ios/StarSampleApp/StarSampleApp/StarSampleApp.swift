//
//  StarSampleApp.swift
//  StarSampleApp
//
//  Created by Bailey Pollard on 2021-11-29.
//

import SwiftUI
import StarSdk
@main
struct PrinterSDK_MiniAppApp: App {
    var body: some Scene {
        let starManager = IosStarManager.companion.create()
        WindowGroup {
            PrinterListView(viewModel: PrinterListViewModel(starManager: starManager), starManager: starManager)
        }
    }
}
