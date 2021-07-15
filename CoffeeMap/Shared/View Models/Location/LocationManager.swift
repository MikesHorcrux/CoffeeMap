//
//  LocationManager.swift
//  CoffeeMap (iOS)
//
//  Created by Mike  Van Amburg on 7/15/21.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()

    @Published var currentLocation: CLLocation?
    var invalidPermission = false

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    var isAuthorized: Bool {
        let status = manager.authorizationStatus
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }

    var isUnAuthorized: Bool {
        let status = manager.authorizationStatus
        return status == .denied
    }

    var unDecidedAuthorization: Bool {
        let status = manager.authorizationStatus
        return status == .notDetermined
    }

    func start() {
        if isAuthorized {
            manager.startUpdatingLocation()
        } else if isUnAuthorized {
            invalidPermission = true
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
}

extension GPS: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if isAuthorized {
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let clError = error as? CLError else { return }

        switch clError {
        case CLError.denied:
            print("Access denied")
            start()
        default:
            print("Catching location error: \(clError)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
}
