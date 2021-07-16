//
//  LocalSearchViewModel.swift
//  CoffeeMap
//
//  Created by Mike  Van Amburg on 7/15/21.
//

import Foundation
import Combine
import MapKit

class LocalSearchViewModel: NSObject, ObservableObject {
    static let shared = LocalSearchViewModel()

    enum LocalSearchStatus: Equatable {
        case idle
        case zeroResults
        case isSearching
        case error(String)
        case result
    }

    @Published var queryFragment: String = ""
    @Published private(set) var searchStatus: LocalSearchStatus = .idle
    @Published private(set) var searchResults: [MKLocalSearchCompletion] = []
    @Published private(set) var searchLocation: [MKMapItem] = []
    private var cancellable: AnyCancellable?
    private let searchCompleter: MKLocalSearchCompleter!

    init(searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
        self.searchCompleter = searchCompleter
        super.init()
        self.searchCompleter.delegate = self

        cancellable = $queryFragment
            .receive(on: DispatchQueue.main)
            // we're debouncing the search, because the search completer is rate limited.
            // feel free to play with the proper value here
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main, options: nil)
            .sink(receiveValue: { fragment in
                self.searchStatus = .isSearching
                if !fragment.isEmpty {
                    self.searchCompleter.queryFragment = fragment
                } else {
                    self.searchStatus = .idle
                    self.searchResults = []
                }
        })
    }
    func find () {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "coffee"

        // Set the region to an associated map view's region.
        searchRequest.region = MKCoordinateRegion.init()

        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                // Handle the error.
                return
            }
            self.searchLocation = response.mapItems
            for item in response.mapItems {
                if let name = item.name,
                    let location = item.placemark.location {
                    print("🤠 location")
                    print("\(name): \(location.coordinate.latitude),\(location.coordinate.longitude)")
                }
            }
//            for item in response.mapItems {
//                if let name = item.name,
//                    let location = item.placemark.location {
//                    print("🤠 location")
//                    print("\(name): \(location.coordinate.latitude),\(location.coordinate.longitude)")
//                }
//            }
        }
    }
}

extension LocalSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResults = completer.results
        self.searchStatus = completer.results.isEmpty ? .zeroResults : .result
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.searchStatus = .error(error.localizedDescription)
    }
}

