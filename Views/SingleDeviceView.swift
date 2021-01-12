//
//  SingleDeviceView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 10/01/2021.
//

import SwiftUI

struct SingleDeviceView: View {
    
    @ObservedObject var done_Single_map = GettingSingleMapData()
    @State var selection = 1
    @State var escolha : String
    
    
    
    var body: some View {
        
        TabView (selection: $selection) {
        
            ZStack {
                VStack {
                    MapView(shared_single: done_Single_map,time:24, escolha: escolha)
                }
                Spinner(isAnimating: done_Single_map.doneGettingSingleMapData, style: .large, color: .green)
            }.tabItem {
                Image(systemName: "map")
                Text("Device position")
             }.tag(1)
            VStack {
                ZStack {
                    Color(.black).edgesIgnoringSafeArea(.all)
                    VStack {
                        BatteryView(device: escolha).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        TempChartView(device: escolha, temperature_intervale: 12)
                    }
                }
            }.tabItem {
                Image(systemName: "thermometer")
                Text("Temperature & Battery")
                }.tag(2)
            VStack {
                DeleteDeviceView(escolha: escolha)
            }.tabItem {
                Image(systemName: "minus.circle.fill")
                Text("Remove Device")
                }.tag(3)
            
            
        }
    }
}

struct SingleDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        SingleDeviceView(escolha: "7B07E7")
    }
}