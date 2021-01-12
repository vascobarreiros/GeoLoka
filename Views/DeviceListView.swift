//
//  DeviceListView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 10/01/2021.
//

import SwiftUI

struct DeviceListView: View {
    
    @ObservedObject var getDevices_by_identifier = GetDevices_by_identifier()
    @State var searchText = ""
    @EnvironmentObject var signInWithAppleMager: SignInWithAppleManager
    @State var tabSelection: Tabs = .tab1
    @ObservedObject var done_All_map = GettingAllMapData()
    @ObservedObject var done_Single_map = GettingSingleMapData()
    @State var selectedDate = Date()
    
    var filteredLokas: [Device] {
        getDevices_by_identifier.lokas_ids.filter { loka in
            ( searchText.isEmpty ? true : loka.device_id.lowercased().contains(searchText.lowercased()) || searchText.isEmpty ? true : loka.device_name.lowercased().contains(searchText.lowercased()))
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                NavigationView {
                    TabView(selection: $tabSelection){
                        List {
                        SearchBar(text: $searchText)
                        ForEach(filteredLokas) {
                            loka in
                            NavigationLink(
                                destination:
                                    SingleDeviceView(done_Single_map: done_Single_map, escolha: loka.device_id),
                                label: {
                                    HStack {
                                        Text(loka.device_id)
                                        Text("-")
                                        Text(loka.device_name)
                                    }
                                })
                            }
                        }
                        .navigationBarTitle("Tab1")
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Map Individual Devices")
                        }.tag(Tabs.tab1)
                        VStack {
                            ZStack {
                                VStack {
                                    MapallLokasView(shared_all: done_All_map, identifier:UserDefaults.standard.string(forKey: signInWithAppleMager.userIdentifierKey)!,delta_hours:48).edgesIgnoringSafeArea(.top)
                                    
                                }
                                Spinner(isAnimating: done_All_map.doneGettingAllMapData, style: .large, color: .green)
                            }
                        }.navigationBarTitle("Tab2")
                        .tabItem {
                            Image(systemName: "person.3.fill")
                            Text("Map All Devices")
                        }.tag(Tabs.tab2)
                        
                        VStack {
                            AddDevicesView()
                        }.navigationBarTitle("Tab3")
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }.tag(Tabs.tab3)
                    }.navigationTitle("Available Devices").navigationBarTitleDisplayMode(/*@START_MENU_TOKEN@*/.inline/*@END_MENU_TOKEN@*/)
                }
            }
        }
        .onAppear {
               getDevices_by_identifier.identifier = UserDefaults.standard.string(forKey: signInWithAppleMager.userIdentifierKey)!
                getDevices_by_identifier.fetchdevices()
                
            }
        
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            self.selectedDate = Date()
            
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            self.selectedDate = Date()
            
        }
        Spinner(isAnimating: getDevices_by_identifier.donefetchingData, style: .large, color: .green)
    }
    
    enum Tabs{
        case tab1, tab2, tab3
    }
    
    
    
    struct DeviceListView_Previews: PreviewProvider {
        static var previews: some View {
            DeviceListView()
        }
    }
}
