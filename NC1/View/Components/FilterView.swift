//
//  FilterView.swift
//  NC1
//
//  Created by Luigi Cirillo on 15/11/23.
//

import SwiftUI
import MapKit

struct FilterView: View {

    var poi : PointOfInterestModel
    
    var body: some View {
        
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(width: 130, height: 100)
                    .foregroundStyle(.ultraThinMaterial)

                VStack(alignment: .center){
                    Image(systemName: poi.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .foregroundStyle(.primary)
                        .padding(5)
                        
                    Text(poi.name)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                }
            
        }
    }
}

#Preview {
    FilterView(poi: PointOfInterestModel(name: "Prova", icon: "cart.fill"))
}
