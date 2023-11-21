//
//  SearchActivationView.swift
//  NC1
//
//  Created by Luigi Cirillo on 14/11/23.
//

import SwiftUI
import MapKit

struct SearchActivationView: View {
    @ObservedObject var MyPlaceViewModel = MyPlacesVM()
    @Binding var showNavigation : Bool
    @Binding var returnedPlace : PlaceModel
    @Binding var bottomSheet : Bool
    
    @Binding var searchResults : [MKMapItem]

    
    @EnvironmentObject var locationManager : LocationManager


    var body: some View {
                VStack{
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showNavigation = true
                                bottomSheet = false
                            }
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 50)
                                    .foregroundStyle(.thinMaterial)
                                    .frame(height: 70)
                                VStack {
                                    HStack{
                                        Image(systemName: "magnifyingglass")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 30)
                                            .foregroundStyle(.gray)
                                            .padding(.trailing, 8)
                                        Text("Where are we going?")
                                            .font(.title3)
                                            .foregroundStyle(.gray)
                                        Spacer()
                                        Image(systemName: "mic.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 30)
                                            .foregroundStyle(.white)
                                            .padding(13)
                                            .background(Circle())
                                            .foregroundStyle(.red)
                                    }
                                    .padding()
                                }
                            }
                        })
                        .accessibilityHint("Open the search view")
                    }

                    Section {
                        ForEach(MyPlaceViewModel.places){ place in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    searchResults.append(MKMapItem(placemark: place.requiredPlacemark))
                                }
                            }, label: {
                                MyPlaceView(mylocation: place)
                            })
                        }
                        
                    }
                    .padding(.horizontal)
                    
                }
        
    }


#Preview {
    SearchActivationView(showNavigation: .constant(true), returnedPlace: .constant(PlaceModel(mapItem: MKMapItem())), bottomSheet: .constant(true), searchResults: .constant([MKMapItem()]))
}


extension SearchActivationView {
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
