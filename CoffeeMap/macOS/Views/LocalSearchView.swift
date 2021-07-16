//
//  LocalSearchView.swift
//  CoffeeMap
//
//  Created by Mike  Van Amburg on 7/15/21.
//

import SwiftUI

struct LocalSearchView: View {
    @ObservedObject var localSearch = LocalSearchViewModel()
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Location Search")) {
                    ZStack(alignment: .trailing) {
                        TextField("Search", text: $localSearch.queryFragment)
                        // This is optional and simply displays an icon during an active search
                        if localSearch.searchStatus == .isSearching {
                            Image(systemName: "clock")
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                Section(header: Text("Results")) {
                    List {
                        // With Xcode 12, this will not be necessary as it supports switch statements.
                        Group { () -> AnyView in
                            switch localSearch.searchStatus {
                            case .zeroResults: return AnyView(Text("No Results"))
                            case .error(let description): return AnyView(Text("Error: \(description)"))
                            default: return AnyView(EmptyView())
                            }
                        }.foregroundColor(Color.gray)

                        ForEach(localSearch.searchResults, id: \.self) { completionResult in
                            // This simply lists the results, use a button in case you'd like to perform an action or use a NavigationLink to move to the next view upon selection.
                            Text(completionResult.title)
                            Text(completionResult.subtitle).font(.footnote)
                        }
                    }
                }
            }
        }
    }
}

struct LocalSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocalSearchView()
    }
}
