//
//  ContentView.swift
//  Shared
//
//  Created by Mike  Van Amburg on 7/15/21.
//

import SwiftUI

struct ContentView: View {
    var localSearch: LocalSearchViewModel
    var body: some View {
        MapView(localVM: localSearch)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(localSearch: LocalSearchViewModel())
    }
}
