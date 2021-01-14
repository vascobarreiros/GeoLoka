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
    @ObservedObject var observer = Observer()
    @State var currentDate = Date()
        let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()
    
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
                                       // Text(loka.device_id)
                                        Text(String(Int(loka.device_id , radix: 16)!))
                                        Text("(\(loka.device_id))")
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
                                    AllDevicesView(identifier: UserDefaults.standard.string(forKey: signInWithAppleMager.userIdentifierKey)!)
                                       }
                                   }
                        }.navigationBarTitle("Tab2")
                        .tabItem {
                            Image(systemName: "person.3.fill")
                            Text("Map All Devices")
                        }.tag(Tabs.tab2)
                        
                        VStack {
                            SettingsView()
                        }.navigationBarTitle("Tab3")
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }.tag(Tabs.tab3)
                        
                        
                    }.navigationTitle("GeoLoKa").navigationBarTitleDisplayMode(/*@START_MENU_TOKEN@*/.inline/*@END_MENU_TOKEN@*/)
                }
            }
            Spinner(isAnimating: getDevices_by_identifier.donefetchingData, style: .large, color: .green)
        }
        .onAppear {
               getDevices_by_identifier.identifier = UserDefaults.standard.string(forKey: signInWithAppleMager.userIdentifierKey)!
                getDevices_by_identifier.fetchdevices()
            }
        .onDisappear {
               getDevices_by_identifier.identifier = UserDefaults.standard.string(forKey: signInWithAppleMager.userIdentifierKey)!
                getDevices_by_identifier.fetchdevices()
            }
        .onReceive(self.observer.$enteredForeground) { _ in
                    print("App entered foreground!") // do stuff here
                   getDevices_by_identifier.identifier = UserDefaults.standard.string(forKey: signInWithAppleMager.userIdentifierKey)!
                    getDevices_by_identifier.fetchdevices()
                }
        .onReceive(timer) { input in
            self.currentDate = input
            print("refreshing")
            getDevices_by_identifier.donefetchingData = true
            getDevices_by_identifier.identifier = UserDefaults.standard.string(forKey: signInWithAppleMager.userIdentifierKey)!
             getDevices_by_identifier.fetchdevices()
                    }
        
    }
    
    enum Tabs{
        case tab1, tab2, tab3
    }
    
    class Observer: ObservableObject {

        @Published var enteredForeground = true

        init() {
            if #available(iOS 13.0, *) {
                NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIScene.willEnterForegroundNotification, object: nil)
            } else {
                NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
            }
        }

        @objc func willEnterForeground() {
            enteredForeground.toggle()
        }
    }
    
    
    
    
    
    
    struct DeviceListView_Previews: PreviewProvider {
        
        
        static var previews: some View {
            DeviceListView()
        }
    }
}
