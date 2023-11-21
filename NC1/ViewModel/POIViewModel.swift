//
//  POIViewModel.swift
//  NC1
//
//  Created by Luigi Cirillo on 15/11/23.
//

import Foundation


class POIViewModel :ObservableObject{
    @Published var poi : [PointOfInterestModel] = [
    PointOfInterestModel(name: "Gas station", icon: "fuelpump.fill"),
    PointOfInterestModel(name: "Food", icon: "fork.knife"),
    PointOfInterestModel(name: "Parking", icon: "parkingsign.circle"),
    PointOfInterestModel(name: "Supermarkets", icon: "cart.fill")
    ]
}
