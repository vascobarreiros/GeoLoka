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
                NavigationLink(destination: Text("1 View")) {
                       Text("Add a New Device")
                   }
                NavigationLink(destination: Text("2 View")) {
                       Text("Set time Interval")
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
