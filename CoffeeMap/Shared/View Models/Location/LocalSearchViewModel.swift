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
