//
//  SearchViewModel.swift
//  NC1
//
//  Created by Luigi Cirillo on 15/11/23.
//

import Foundation
import MapKit
import SwiftUI


class SearchViewModel {

    init(searchResults: Binding<[MKMapItem]>) {
        _searchResults = searchResults
    }
    @Binding  var searchResults : [MKMapItem]
    
    func search (for query: String) {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = query
    request.resultTypes = .pointOfInterest
    request.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43, longitude: 34) , span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    Task{
        let search = MKLocalSearch(request: request)
        let response = try? await search.start()
        searchResults = response?.mapItems ?? []
    }
}
}
