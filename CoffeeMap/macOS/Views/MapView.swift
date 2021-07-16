//
//  MapView.swift
//  CoffeeMap
//
//  Created by Mike  Van Amburg on 7/15/21.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Environment(\.locationManagerViewModel) private var locationManager
    @State private var trackingMode = MapUserTrackingMode.follow
    @State private var region: MKCoordinateRegion = .init()
    @State var location: [Shop] {
        self.location = locationManager.annotation
    }
    var body: some View {

        Map(
            coordinateRegion: $region,
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: $trackingMode,
            annotationItems: location
        ){ item in
            MapAnnotation(coordinate: item.shop.location?.coordinate ?? .init()){
                Circle()

            }
        }

    }

}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
