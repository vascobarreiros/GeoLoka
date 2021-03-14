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
    @State var hours: Int = 24
    @State private var selectorIndex = 1
    @State private var accuracy = ["All","0-100","100-500","500-1000"," > 1000"]
    @State private var accuracyNumber = [1000000.0,100.0,500.0,1000.0]
    
    var body: some View {
        
        TabView (selection: $selection) {
        
            ZStack {
                VStack {
                    Text(NSLocalizedString("GeoPosition Accuracy(m)",comment: ""))
                    Picker("", selection: $selectorIndex) {
                        ForEach(0 ..< accuracyNumber.count) { index in
                            Text(self.accuracy[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    MapViewSingleDevice(shared_single: done_Single_map,time:hours, escolha: escolha, raio: accuracyNumber[selectorIndex]).ignoresSafeArea()
                    HStack {
                        Text("Last")
                        Picker("", selection: $hours){
                                            ForEach(1..<72, id: \.self) { i in
                                                Text("\(i) hours")
                                            }
                                        }.pickerStyle(WheelPickerStyle())
                                        .clipped()
                                        .scaledToFit()
                                        .font(.caption)
                                        .frame(width:300.0, height: 90.0)
                    }
                                    

                }
                Spinner(isAnimating: done_Single_map.doneGettingSingleMapData, style: .large, color: .green)
            }.tabItem {
                Image(systemName: "map")
                Text(NSLocalizedString("Device position", comment: ""))
             }.tag(1)
            VStack {
                ZStack {
                    Color(.black).edgesIgnoringSafeArea(.all)
                    VStack {
                        BatteryView(device: escolha).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        TempChartViewNew(escolha: escolha)
                    }
                }
            }.tabItem {
                Image(systemName: "thermometer")
                Text(NSLocalizedString("Temperature & Battery", comment: ""))
                }.tag(2)
            VStack {
                DeleteDeviceView(escolha: escolha)
            }.tabItem {
                Image(systemName: "minus.circle.fill")
                Text(NSLocalizedString("Remove Device",comment: ""))
                }.tag(3)
            
            VStack {
                DeviceDetailsView(escolha: escolha)
            }.tabItem {
                Image(systemName: "person.crop.square.fill.and.at.rectangle")
                Text(NSLocalizedString("Device Details",comment: ""))
                }.tag(4)
            
            
            
            
        }
    }
}

struct SingleDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        SingleDeviceView(escolha: "7B07E7")
    }
}
