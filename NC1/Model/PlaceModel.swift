//
//  PlaceModel.swift
//  NC1
//
//  Created by Luigi Cirillo on 15/11/23.
//

import Foundation
import MapKit

struct PlaceModel :Identifiable, Equatable {
    let id = UUID().uuidString
     
    var mapItem: MKMapItem
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    var name: String {
        self.mapItem.name ?? ""
    }
    var address : String {
        let placemark = self.mapItem.placemark
        var cityAndState = ""
        var address = ""
        
        cityAndState = placemark.locality ?? "" //city
        if let state = placemark.administrativeArea {
            //show either state or city
            cityAndState = cityAndState.isEmpty ? state : "\(cityAndState), \(state)"
        }
        address = placemark.subThoroughfare ?? ""
        if let street = placemark.thoroughfare {
            address = address.isEmpty ? street : "\(address), \(street)"
        }
        if address.trimmingCharacters(in: .whitespaces).isEmpty && !cityAndState.isEmpty {
            address = cityAndState
        } else {
            address = cityAndState.isEmpty ? address : "\(address), \(cityAndState)"
        }
        return address
    }
    
    var latitude : Double {
        get {
            self.mapItem.placemark.coordinate.latitude
        }
        set {
            var coordinate = self.mapItem.placemark.coordinate
            coordinate.latitude = newValue
            self.mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        }
    }
    
    var longitude : Double {
        get {
            self.mapItem.placemark.coordinate.longitude
        }
        set {
            var coordinate = self.mapItem.placemark.coordinate
            coordinate.longitude = newValue
            self.mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        }
    }
    
    static func createWithCustomName(mapItem: MKMapItem, customName: String) -> PlaceModel {
        let place = PlaceModel(mapItem: mapItem)
            place.mapItem.name = customName
            return place
        }
    
    var requiredPlacemark: MKPlacemark {
            return self.mapItem.placemark
        }
}

