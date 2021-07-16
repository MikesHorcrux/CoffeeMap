//
//  CoffeeMapApp.swift
//  Shared
//
//  Created by Mike  Van Amburg on 7/15/21.
//

import SwiftUI

@main
struct CoffeeMapApp: App {

    @Environment(\.localSearchViewModel) private var localSearch
    @Environment(\.locationManagerViewModel) private var locationManager
    var body: some Scene {
        WindowGroup {
            ContentView(localSearch: localSearch)
                .onAppear(perform: {
                    locationManager.start()
                })
        }
    }
}
