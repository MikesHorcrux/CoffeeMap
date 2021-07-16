//
//  MapView.swift
//  CoffeeMap
//
//  Created by Mike  Van Amburg on 7/15/21.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var localSearch = LocalSearchViewModel()
    @ObservedObject var LocationManager = LocationManagerViewModel()
    @State private var trackingMode = MapUserTrackingMode.follow
    @State private var region: MKCoordinateRegion = .init()
    @State var location: [Shop] = []
    let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    var body: some View {

        Map(
            coordinateRegion: $region,
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: $trackingMode,
            annotationItems: LocationManager.annotation
        ){ item in
            MapAnnotation(coordinate: item.shop.location?.coordinate ?? .init()){
                Circle().frame(width: 100, height: 1000, alignment: .center)
                    .foregroundColor(.red)

            }
        }

    }

}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
