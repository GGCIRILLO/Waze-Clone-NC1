//
//  NC1App.swift
//  NC1
//
//  Created by Luigi Cirillo on 14/11/23.
//

import SwiftUI

@main
struct NC1App: App {
    @StateObject var locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationManager)
        }
    }
}
