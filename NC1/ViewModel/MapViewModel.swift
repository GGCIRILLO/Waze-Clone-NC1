//
//  MapViewModel.swift
//  NC1
//
//  Created by Luigi Cirillo on 17/11/23.
//

import SwiftUI
import MapKit


@MainActor
class MapViewModel: ObservableObject {
    @Published var locationManager = LocationManager()
    @Published var selected: MKMapItem?
    @Published var route: MKRoute?
    @Published var routeDestination: MKMapItem?
    @Published var routeDisplaying = false
    @Published var showDetails: Bool = false
    @Published var cameraPosition: MapCameraPosition = .automatic
    
    
    func fetchRoute() {
        if let selected = selected {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: CLLocationCoordinate2D(latitude: locationManager.region.center.latitude, longitude: locationManager.region.center.longitude)))
            request.destination = selected
            
            Task {
                do {
                    let result = try await MKDirections(request: request).calculate()
                    
                    // Perform the following updates on the main thread
                    Task {
                        self.route = result.routes.first
                        self.routeDestination = selected
                        self.routeDisplaying = true
                        
                        
                        withAnimation(.snappy) {
                            if let rect = self.route?.polyline.boundingMapRect, self.routeDisplaying {
                                self.cameraPosition = .rect(rect)
                            }
                            
                        }
                    }.cancel()
                    
                } catch {
                    // Handle errors if needed
                    print("Error calculating route: \(error.localizedDescription)")
                }
            }
        }
    }
}
