//
//  Shop.swift
//  CoffeeMap (iOS)
//
//  Created by Mike  Van Amburg on 7/15/21.
//

import Foundation
import MapKit

struct Shop: Identifiable {
    var id = UUID().uuidString
    var shop: CLPlacemark
}
