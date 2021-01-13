//
//  AllDevicesView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 12/01/2021.
//

import SwiftUI

struct AllDevicesView: View {
    
    @ObservedObject var done_All_map = GettingAllMapData()
    @EnvironmentObject var signInWithAppleMager: SignInWithAppleManager
    @State private var selectorIndex = 1
    @State private var accuracy = ["All","0-100","100-500","500-1000"," > 1000"]
    @State private var accuracyNumber = [1000000.0,100.0,500.0,1000.0]
    var identifier : String
    
    var body: some View {
        VStack {
            Text("GeoPosition Accuracy(m)")
            Picker("", selection: $selectorIndex) {
                ForEach(0 ..< accuracyNumber.count) { index in
                    Text(self.accuracy[index]).tag(index)
                }
            }.pickerStyle(SegmentedPickerStyle())
            ZStack {
                VStack {
                    MapallLokasView(shared_all: done_All_map, identifier:identifier,delta_hours:48, raio: accuracyNumber[selectorIndex]).edgesIgnoringSafeArea(.bottom)
                }
                   Spinner(isAnimating: done_All_map.doneGettingAllMapData, style: .large, color: .green)
            }
        }
    }
}

struct AllDevicesView_Previews: PreviewProvider {
    static var previews: some View {
        AllDevicesView( identifier: "000156.42f100f369164279a37b77c63f2dab3f.1008")
    }
}
