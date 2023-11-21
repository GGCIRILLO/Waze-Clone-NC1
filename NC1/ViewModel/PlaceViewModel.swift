//
//  PlaceViewModel.swift
//  NC1
//
//  Created by Luigi Cirillo on 15/11/23.
//

import Foundation
import MapKit

@MainActor

class PlaceViewModel : ObservableObject{
    @Published var places : [PlaceModel] = []
    
    func search(text: String, region: MKCoordinateRegion){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = region
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }
            
            self.places = response.mapItems.map(PlaceModel.init)
        }
    }
}
