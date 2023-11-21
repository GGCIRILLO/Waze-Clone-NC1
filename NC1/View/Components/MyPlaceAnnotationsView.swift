//
//  MyPlaceAnnotationsView.swift
//  NC1
//
//  Created by Luigi Cirillo on 16/11/23.
//

import SwiftUI
import CoreLocation

struct MyPlaceAnnotationsView: View {
    var mylocation : MyLocationsModel

    var body: some View {
        VStack {
            ZStack(content: {
                Circle()
                    .foregroundStyle(.white)
                    .frame(width: 50)
                Circle()
                    .frame(width: 40)
                    .foregroundStyle(.cyan)
                Image(systemName: mylocation.icon)
                    .font(.title2)
                    .foregroundStyle(.white)
            })
            Image(systemName: "arrowtriangle.down.fill")
                .padding(.top, -6)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    MyPlaceAnnotationsView(mylocation: MyLocationsModel(name: "Prova", icon: "house.fill", coordinates: CLLocationCoordinate2D(latitude: 40, longitude: 50), address: "prova", city: "prova"))
}
