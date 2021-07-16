//
//  LocalSearchView.swift
//  CoffeeMap
//
//  Created by Mike  Van Amburg on 7/15/21.
//

import SwiftUI
import MapKit

struct LocalSearchView: View {
    @ObservedObject var localSearch = LocalSearchViewModel()
    @ObservedObject var LocationManager = LocationManagerViewModel()
    @State private var trackingMode = MapUserTrackingMode.follow
    @State private var region: MKCoordinateRegion = .init()
    var body: some View {

        ZStack {
            Map(
                coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: $trackingMode,
                annotationItems: LocationManager.annotation
            ){ item in
                MapAnnotation(coordinate: item.shop.location?.coordinate ?? .init()){
                    Circle().frame(width: 100, height: 1000, alignment: .center)
                        .foregroundColor(.red)

                }
            }

        }

            VStack {
                    Form {
                        Section(header: Text("Search location")) {
                            TextField("search", text: $LocationManager.searchedLocal)

                            if !LocationManager.shops.isEmpty && LocationManager.searchedLocal != "" {
                                VStack{
                                    ScrollView{
                                    ForEach(LocationManager.shops){ shops in
                                        VStack {
                                            Text(shops.shop.name ?? "")
                                            HStack {
                                                Text(shops.shop.locality ?? "")
                                                Text(shops.shop.postalCode ?? "")
                                            }
                                        }
                                        .onTapGesture {
                                            LocationManager.selectShop(shop: shops)
                                        }
                                        Divider()
                                    }
                                }
                                }
                            }
                        }
                        .onChange(of: LocationManager.searchedLocal) { value in
                            let delay = 0.5
                            DispatchQueue.main.asyncAfter(deadline: .now() + delay){
                                if value == LocationManager.searchedLocal{
                                    self.LocationManager.searchQuery()
                                }
                            }
                        }
                        Spacer()
                    }
                    .frame(width: nil, height: 300, alignment: .center)

            }
        }
//        VStack {
//            Form {
//                Section(header: Text("Location Search")) {
//                    ZStack(alignment: .trailing) {
//                        TextField("Search", text: $localSearch.queryFragment)
//                        // This is optional and simply displays an icon during an active search
//                        if localSearch.searchStatus == .isSearching {
//                            Image(systemName: "clock")
//                                .foregroundColor(Color.gray)
//                        }
//                    }
//                }
//                Section(header: Text("Results")) {
//                    List {
//                        // With Xcode 12, this will not be necessary as it supports switch statements.
//                        Group { () -> AnyView in
//                            switch localSearch.searchStatus {
//                            case .zeroResults: return AnyView(Text("No Results"))
//                            case .error(let description): return AnyView(Text("Error: \(description)"))
//                            default: return AnyView(EmptyView())
//                            }
//                        }.foregroundColor(Color.gray)
//
//                        ForEach(localSearch.searchResults, id: \.self) { completionResult in
//                            // This simply lists the results, use a button in case you'd like to perform an action or use a NavigationLink to move to the next view upon selection.
//                            Text(completionResult.title)
//                            Text(completionResult.subtitle).font(.footnote)
//                            Button("button") {
//                                localSearch.find()
//                            }
//                        }
//                    }
//                }
//            }
//        }
    
}

struct LocalSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocalSearchView()
    }
}
