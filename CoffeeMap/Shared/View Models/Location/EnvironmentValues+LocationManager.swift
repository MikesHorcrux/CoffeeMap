//
//  EnvironmentValues+gps.swift
//  CoffeeMap (iOS)
//
//  Created by Mike  Van Amburg on 7/15/21.
//

import SwiftUI

struct LocationManagerEnvironmentKey: EnvironmentKey {
    static let defaultValue = LocationManagerViewModel.shared
}

extension EnvironmentValues {
    var locationManagerViewModel: LocationManagerViewModel {
        get {
            self[LocationManagerEnvironmentKey.self]
        }
        set {
            self[LocationManagerEnvironmentKey.self] = newValue
        }
    }
}

struct LocalSearchEnvironmentKey: EnvironmentKey {
    static let defaultValue = LocalSearchViewModel.shared
}

extension EnvironmentValues {
    var localSearchViewModel: LocalSearchViewModel {
        get {
            self[LocalSearchEnvironmentKey.self]
        }
        set {
            self[LocalSearchEnvironmentKey.self] = newValue
        }
    }
}
