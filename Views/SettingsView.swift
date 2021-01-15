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
                NavigationLink(destination: Text("TBD")) {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                        Text(NSLocalizedString("Set time Interval",comment: ""))
                    }
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
