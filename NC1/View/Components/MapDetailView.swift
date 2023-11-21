//
//  MapDetailView.swift
//  NC1
//
//  Created by Luigi Cirillo on 16/11/23.
//

import SwiftUI
import MapKit

struct MapDetailView: View {
    @State var lookAroundScene : MKLookAroundScene?
    @Binding var mapSelection : MKMapItem?
    @Binding var show: Bool
    @Binding var bottomSheet : Bool
    @Binding var getDirections : Bool
    
    var body: some View {
        VStack {
    
            HStack{
                VStack(alignment: .leading, spacing: nil, content: {
                    Text(mapSelection?.placemark.name ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(mapSelection?.placemark.title ?? "")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .padding(.trailing)
                })
                
                Spacer()
                Button(action: {
                    show.toggle()
                    bottomSheet.toggle()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width:30, height: 30)
                })
                .accessibilityLabel("Close place detail")
                
            }
            if let scene = lookAroundScene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding()
                    .accessibilityHidden(true)
            } else {
                ContentUnavailableView("No Preview Available", systemImage: "eye.slash")
                    .accessibilityHidden(true)
            }
            
            Button("Get directions") {
                getDirections.toggle()
                
            }
            .accessibilityHint("Show the route to this place")
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(.teal.gradient, in: .rect(cornerRadius: 20))
            
            .onAppear{
                fetchLookAroundPreview()
            }
            .onChange(of: mapSelection) { oldValue, newValue in 
                fetchLookAroundPreview()
            }
        }
        .padding()
    }
}

#Preview {
    MapDetailView(mapSelection: .constant(MKMapItem()), show: .constant(true), bottomSheet: .constant(true), getDirections: .constant(true))
        .environmentObject(LocationManager())
}

extension MapDetailView {
    func fetchLookAroundPreview() {
        if let mapSelection {
            lookAroundScene = nil
            Task{
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                lookAroundScene = try? await request.scene
            }
        }
    }
}
