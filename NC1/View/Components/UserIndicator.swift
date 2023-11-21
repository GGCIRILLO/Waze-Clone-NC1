//
//  UserIndicator.swift
//  NC1
//
//  Created by Luigi Cirillo on 14/11/23.
//

import SwiftUI

struct UserIndicator: View {
    var body: some View {
        ZStack{
            Circle()
                .fill(.secondary)
                .frame(height: 45)
                .opacity(0.4)
                .brightness(0.005)
            Image(systemName: "location.north.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
                .foregroundStyle(.white)
            Image(systemName: "location.north.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 25)
                .foregroundStyle(.cyan)
        }
    }
}

#Preview {
    UserIndicator()
}
