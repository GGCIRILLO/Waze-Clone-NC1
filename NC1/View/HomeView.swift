//
//  HomeView.swift
//  NC1
//
//  Created by Luigi Cirillo on 14/11/23.
//

import SwiftUI
import MapKit

struct HomeView: View {
 
    @Namespace private var locationSpace
    
    @State var returnedPlace = PlaceModel(mapItem: MKMapItem())
    @State private var searchResults : [MKMapItem] = []
        
    @State private var showNavigation = false
    @State private var bottomSheet = true
    
    @ObservedObject var myPlaceViewModel = MyPlacesVM()
    
    @State private var lookAroundScene : MKLookAroundScene?
    
    @State private var getDirections : Bool = false
    
    @StateObject private var viewModel = MapViewModel()
    
    
    var body: some View {
        NavigationView{
            
            mapView
                .accessibilityLabel("Map")
                .ignoresSafeArea()
                .mapControlVisibility(.visible)
                .sheet(isPresented: $bottomSheet, onDismiss: .none, content: {
                    SearchActivationView(showNavigation: $showNavigation, returnedPlace: $returnedPlace, bottomSheet: $bottomSheet, searchResults: $searchResults)
                        .padding()
                        .presentationDetents([.fraction(0.3)])
                        .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.3)))
                        .presentationCornerRadius(30)
                        .interactiveDismissDisabled()
                        .presentationDragIndicator(.visible)
                })
                .sheet(isPresented: $showNavigation, content: {
                    SearchView(returnedPlace: $returnedPlace, searchResults: $searchResults, bottomSheet: $bottomSheet, showNavigation: $showNavigation)
                        .presentationDetents([.medium, .large])
                        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                        .interactiveDismissDisabled()
                        .presentationCornerRadius(30)
                })
            //Map Controls
                .overlay(alignment: .bottomLeading){
                    controlsOverlay
                }
                .mapScope(locationSpace)
                .controlSize(.regular)
                .mapStyle(.standard(elevation: .realistic))
                .onChange(of: searchResults) {
                    withAnimation(.easeInOut(duration: 5)) {
                        viewModel.cameraPosition = .automatic
                    }
                }
                .onChange(of: viewModel.selected) { oldValue, newValue in
                    //if the new value of selected is not nil we show the details
                    viewModel.showDetails = newValue != nil
                    
                    if viewModel.selected == nil {
                        bottomSheet = true
                    } else {
                        bottomSheet = false
                    }
                }
                .sheet(isPresented: $viewModel.showDetails) {
                    MapDetailView( mapSelection: $viewModel.selected, show: $viewModel.showDetails, bottomSheet: $bottomSheet, getDirections: $getDirections)
                        .presentationDetents([.medium])
                        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                        .interactiveDismissDisabled()
                        .presentationCornerRadius(30)
                        .accessibilityAddTraits(.isModal)
                }
                .onChange(of: getDirections) { oldValue, newValue in
                    if newValue {
                        viewModel.fetchRoute()
                    }
                }
            }
    }
    private var mapView: some View {
        Map(position: $viewModel.cameraPosition, selection: $viewModel.selected, scope: locationSpace) {
            UserAnnotation {
                UserIndicator()
            }
            
            ForEach(searchResults, id: \.self){ result in
                if viewModel.routeDisplaying {
                    if result == viewModel.routeDestination {
                       Marker(item: result)
                    }
                } else {
                    Marker(item: result)
                }
            }
            .tint(.teal)
            
            ForEach(myPlaceViewModel.places, id: \.id) { myPlace in
                Marker(myPlace.name, systemImage: {
                    if myPlace.name == "House" {
                        return "house.fill"
                    } else {
                        return "folder.fill"
                    }
                }(), coordinate: CLLocationCoordinate2D(latitude: myPlace.latitude, longitude: myPlace.longitude))
            }
            .annotationTitles(.hidden)
            .tint(.teal)
            


            if let route = viewModel.route {
                MapPolyline(route.polyline)
                    .stroke(.teal, lineWidth: 6)
            }
            
            
        }
    }

    private var controlsOverlay: some View {
        HStack(spacing: 15) {
            MapUserLocationButton(scope: locationSpace)
            MapPitchToggle(scope: locationSpace)
            //button to clean the search results
            if !searchResults.isEmpty {
                Button {
                    searchResults.removeAll(keepingCapacity: false)
                    viewModel.showDetails = false
                    viewModel.route = nil
                    viewModel.routeDisplaying = false
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width:15, height: 15)
                        .foregroundStyle(.teal)
                        .padding(15)
                        .background(Circle())
                        .foregroundStyle(.white)
                }
                .accessibilityLabel("Remove selection and route displaying")
            }
        }
        .offset(y: !showNavigation ? CGFloat(-UIScreen.main.bounds.height)/3.8 : CGFloat(-UIScreen.main.bounds.height)/2)
        .padding()
        .buttonBorderShape(.circle)
        .buttonStyle(.bordered)
    }
}



#Preview {
    HomeView()
        .environmentObject(LocationManager())
}


