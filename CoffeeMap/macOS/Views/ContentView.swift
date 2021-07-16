//
//  ContentView.swift
//  Shared
//
//  Created by Mike  Van Amburg on 7/15/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var localSearch = LocalSearchViewModel()
    @StateObject var LocationManager = LocationManagerViewModel()
    @Environment(\.locationManagerViewModel) private var locationManager

    var body: some View {

        NavigationView{
            LocalSearchView()
            MapView()
        }


        


    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
