//
//  SearchView.swift
//  NC1
//
//  Created by Luigi Cirillo on 15/11/23.
//

import SwiftUI
import MapKit

struct SearchView: View {
    @State private var searchText = ""
    @ObservedObject var POIviewModel = POIViewModel()
    @ObservedObject var myPlaceViewModel = MyPlacesVM()
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var locationManager : LocationManager
    
    @StateObject var placeVM = PlaceViewModel()
    @Binding var returnedPlace : PlaceModel
    @Binding var searchResults : [MKMapItem]
    
    @Binding var bottomSheet : Bool
    @Binding var showNavigation : Bool 

    
    
    var body: some View {
        NavigationView {
            VStack{
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .foregroundStyle(.thinMaterial)
                        .frame(height: 70)
                    HStack{
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                bottomSheet = true
                                showNavigation = false
                            }
                        }, label: {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                                .foregroundStyle(.gray)
                                .padding(.trailing, 8)
                        })
                        
                        TextField("Where are we going?", text: $searchText)
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
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(POIviewModel.poi){ poi in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    bottomSheet = true
                                    showNavigation = false
                                }
                                search(for: poi.name)
                            }, label: {
                                FilterView(poi: poi)
                            })
                            .accessibilityAddTraits(.isButton)
                            .accessibilityHint("Search for" + poi.name + " around you")
                            
                        }
                        
                    }
                    .padding(.horizontal)
                }
                if searchText.isEmpty {
                    Section {
                        ForEach(myPlaceViewModel.places){ place in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    searchResults.append(MKMapItem(placemark: place.requiredPlacemark))
                                    bottomSheet =  true
                                    showNavigation = false
                                }
                            }, label: {
                                MyPlaceView(mylocation: place)
                                Spacer()
                            })
                        }
                        .padding()
                    }
                } else {
                    List(placeVM.places) { place in
                        VStack(alignment: .leading) {
                            Text(place.name)
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.primary)
                                .padding(.vertical, 2)
                            Text(place.address)
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundStyle(.primary)
                        }
                        .accessibilityElement(children: .combine)
                        .onTapGesture(perform: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                searchResults.append(MKMapItem(placemark: place.requiredPlacemark))
                                bottomSheet = true
                                showNavigation = false
                            }
                        })
                    }
                    .listStyle(.plain)
                    .onChange(of: searchText) {
                        if !searchText.isEmpty {
                            search(for: searchText)
                            placeVM.search(text: searchText, region: locationManager.region)
                        } else {
                            searchResults = []
                            placeVM.places = []
                        }
                    }
                }
            }
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    SearchView(returnedPlace: .constant(PlaceModel(mapItem: MKMapItem())), searchResults: .constant([MKMapItem()]), bottomSheet: .constant(true), showNavigation: .constant(true))
}

extension SearchView {
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
