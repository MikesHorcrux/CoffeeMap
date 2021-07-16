//
//  LocationState.swift
//  CoffeeMap
//
//  Created by Mike  Van Amburg on 7/16/21.
//

import Foundation
import MapKit

struct LocationState {

    var currentLocation: CLLocation? = .init()
    var currentRegion: MKCoordinateRegion = .init()
    var searchedLocal: String = ""
    var shops: [Shop] = []
    var annotation: [Shop] = []
    var invalidPermission = false
}
