//
//  EnvironmentValues+gps.swift
//  CoffeeMap (iOS)
//
//  Created by Mike  Van Amburg on 7/15/21.
//

import Foundation

import SwiftUI

struct LocationManagerEnvironmentKey: EnvironmentKey {
    static let defaultValue = GPS.shared
}

extension EnvironmentValues {
    var locationManager: LocationManager {
        get {
            self[LocationManagerEnvironmentKey.self]
        }
        set {
            self[LocationManagerEnvironmentKey.self] = newValue
        }
    }
}
