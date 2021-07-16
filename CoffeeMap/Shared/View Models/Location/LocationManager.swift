//
//  LocationManager.swift
//  CoffeeMap (iOS)
//
//  Created by Mike  Van Amburg on 7/15/21.
//

import Foundation
import CoreLocation

final class LocationManagerViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManagerViewModel()

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
        #if os(iOS)
        return status == .authorizedAlways || status == .authorizedWhenInUse
        #endif

        #if os(macOS)
        return status == .authorizedAlways || status == .authorized
        #endif
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

extension LocationManagerViewModel {
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
