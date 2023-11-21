//
//  MyPlacesVM.swift
//  NC1
//
//  Created by Luigi Cirillo on 16/11/23.
//

import Foundation
import MapKit

class MyPlacesVM: ObservableObject {
    
    lazy var houseMapItem: MKMapItem = {
        return MKMapItem(placemark: MKPlacemark(
            coordinate: CLLocationCoordinate2D(
                latitude: 40.87114245510131,
                longitude: 14.263620478305086)))
    }()

    lazy var workMapItem: MKMapItem = {
        return MKMapItem(placemark: MKPlacemark(
            coordinate: CLLocationCoordinate2D(
                latitude: 40.836734,
                longitude: 14.30596)))
    }()

    lazy var house: PlaceModel = {
        return PlaceModel.createWithCustomName(mapItem: houseMapItem, customName: "House")
    }()

    lazy var work: PlaceModel = {
        return PlaceModel.createWithCustomName(mapItem: workMapItem, customName: "Work")
    }()

    @Published var places: [PlaceModel] = []

    init() {
        // Initialize the places array in the init method
        places = [house, work]
    }
}
