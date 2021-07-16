//
//  ContentView.swift
//  Shared
//
//  Created by Mike  Van Amburg on 7/15/21.
//

import SwiftUI

struct ContentView: View {

    @Environment(\.locationManagerViewModel) private var locationManager

    var body: some View {


            LocalSearchView()

        


    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
