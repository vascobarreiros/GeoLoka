//
//  SettingsView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 12/01/2021.
//

import SwiftUI

struct SettingsView: View {
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                NavigationLink(destination: AddDevicesView()) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Image(systemName: "car.2.fill")
                        Text(NSLocalizedString("Add a New Device",comment: ""))
                    }
                   }
                    NavigationLink(destination: AddGeoFencingView()) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Image(systemName: "mappin.and.ellipse")
                        Text(NSLocalizedString("Add GeoFencing",comment: ""))
                    }}
                    NavigationLink(destination: MapViewGeoFencing()) {
                    HStack {
                        Image(systemName: "eye.circle")
                        Image(systemName: "mappin.and.ellipse")
                        Text(NSLocalizedString("View GeoFencing",comment: ""))
                    }}
                HStack {
                        Image(systemName: "hand.raised.fill")
                        Link("Privacy Policy", destination: URL(string: "https://martynet.pt/geoloka.html")!)
                    }
                }
                .navigationTitle("Settings").navigationBarTitleDisplayMode(/*@START_MENU_TOKEN@*/.inline/*@END_MENU_TOKEN@*/)
            }
        
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
