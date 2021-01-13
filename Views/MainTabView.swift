//
//  MainTabView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 08/01/2021.
//

import SwiftUI

struct MainTabView: View {
    
    @State var searchText = ""
    @EnvironmentObject var signInWithAppleMager: SignInWithAppleManager
    @ObservedObject var getdevices = GetDevices()
    @State var tabSelection: Tabs = .tab1
    @ObservedObject var done_All_map = GettingAllMapData()
    @ObservedObject var done_Single_map = GettingSingleMapData()

    
    var filteredLokas: [Device] {
        getdevices.lokas_ids.filter { loka in
            (loka.identifier == UserDefaults.standard.string(forKey: signInWithAppleMager.userIdentifierKey)! && searchText.isEmpty ? true : loka.device_id.lowercased().contains(searchText.lowercased()) || searchText.isEmpty ? true : loka.device_name.lowercased().contains(searchText.lowercased()))
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                NavigationView {
                    TabView(selection: $tabSelection){
                        List {
                            SearchBar(text: $searchText)
                            ForEach(filteredLokas) { loka in
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
                        }.navigationBarTitle("Tab1")
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Map Individual Devices")
                        }.tag(Tabs.tab1)
                        VStack {
                            ZStack {
                                VStack {
                                    MapallLokasView(shared_all: done_All_map, identifier:UserDefaults.standard.string(forKey: signInWithAppleMager.userIdentifierKey)!,delta_hours:48, raio: 100).edgesIgnoringSafeArea(.top)
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
                            Image(systemName: "plus.circle.fill")
                            Text("Add Devices")
                        }.tag(Tabs.tab3)
                        
                        
                    }.navigationTitle("Available Devices").navigationBarTitleDisplayMode(/*@START_MENU_TOKEN@*/.inline/*@END_MENU_TOKEN@*/)
                }
                }
            }
            Spinner(isAnimating: getdevices.donefetchingData, style: .large, color: .green)
        }

    }
    
    enum Tabs{
        case tab1, tab2, tab3
    }


struct MainTabView_Previews: PreviewProvider {
    
    static var previews: some View {
        MainTabView()
    }
}
