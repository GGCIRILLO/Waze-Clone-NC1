//
//  MyPlaceView.swift
//  NC1
//
//  Created by Luigi Cirillo on 15/11/23.
//

import SwiftUI
import MapKit

struct MyPlaceView: View {
    var mylocation : PlaceModel
    
    
    var body: some View {
        HStack{
            VStack {
                if mylocation.name == "House" {
                    Image(systemName: "house.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.primary)
                        .frame(height: 30)
                        .padding(.trailing)

                } else {
                    Image(systemName: "folder.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.primary)
                        .frame(height: 30)
                        .padding(.trailing)
                }
            }
            
            VStack(alignment: .leading){
                Text(mylocation.name)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.primary)
                    .padding(.vertical, 2)
                Text(mylocation.mapItem.placemark.title ?? "")
                    .lineLimit(2)
                    .fontWeight(.regular)
                    .foregroundStyle(.secondary)
                    .font(.headline)
                
            }
            Spacer()
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(mylocation.name)
        .accessibilityHint("Highlights " + mylocation.name)
    }
}

#Preview {
    MyPlaceView(mylocation: PlaceModel(mapItem: MKMapItem()))
}
