//
//  LocationManager.swift
//  CoffeeMap (iOS)
//
//  Created by Mike  Van Amburg on 7/15/21.
//

import Foundation
import CoreLocation
import MapKit
import Combine

final class LocationManagerViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManagerViewModel()

    @Published var currentLocation: CLLocation?
    @Published var currentRegion: MKCoordinateRegion?
    @Published var searchedLocal: String = ""
    @Published var shops: [Shop] = []
    @Published var annotation: [Shop] = []
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

    func searchQuery(){
        shops.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchedLocal

        // fetch
        MKLocalSearch(request: request).start { (response, _) in
            guard let result = response else { return }

            self.shops = result.mapItems.compactMap({ (item) -> Shop? in
                return Shop(shop: item.placemark)
            })
        }
    }


    func selectShop(shop: Shop){
        annotation.removeAll()
        searchedLocal = ""
        guard let coordinate = shop.shop.location?.coordinate else {
            return
        }

        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = shop.shop.name ?? ""

        currentRegion = MKCoordinateRegion(center: shop.shop.location!.coordinate, latitudinalMeters: 20, longitudinalMeters: 20)
        let chosenShop = Shop(id: shop.id, shop: shop.shop)
        annotation.append(chosenShop)
        print(annotation)
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
        currentRegion = MKCoordinateRegion(center: currentLocation?.coordinate ?? .init(), latitudinalMeters: 1000, longitudinalMeters: 1000)

    }
}
