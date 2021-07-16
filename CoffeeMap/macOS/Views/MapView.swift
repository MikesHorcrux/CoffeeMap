//
//  MapView.swift
//  CoffeeMap
//
//  Created by Mike  Van Amburg on 7/15/21.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var localVM: LocalSearchViewModel
    @State private var trackingMode = MapUserTrackingMode.follow
    @State private var region: MKCoordinateRegion = .init()

    var body: some View {
        Map(
            coordinateRegion: $region,
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: $trackingMode
        )
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(localVM: LocalSearchViewModel())
    }
}
