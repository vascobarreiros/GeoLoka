//
//  testView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 11/01/2021.
//

import SwiftUI

struct lokaListView: View {
    
    @State var showRefreshView: Bool = false
    @ObservedObject var getDevices_by_identifier = GetDevices_by_identifier()
    @ObservedObject var done_Single_map = GettingSingleMapData()
    @EnvironmentObject var signInWithAppleMager: SignInWithAppleManager
    @State var tabSelection: Tabs = .tab1
    
    var body: some View {
        
        ZStack {
            VStack {
                TabView(selection: $tabSelection){
                 
                    RefreshableNavigationView(title: "Devices List (Pull to refresh)", showRefreshView: $showRefreshView, displayMode: .inline, action:{
                        getDevices_by_identifier.fetchdevices()
                        getDevices_by_identifier.identifier = UserDefaults.standard.string(forKey: signInWithAppleMager.userIdentifierKey)!
                        self.showRefreshView = false
                    }){
                
                        ForEach(getDevices_by_identifier.lokas_ids){ loka in
                            VStack(alignment: .leading) {
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
                    
                }
                //???
            }
        }
    }
    
    enum Tabs{
        case tab1, tab2, tab3
    }
}





struct lokaListView_Previews: PreviewProvider {
    static var previews: some View {
        lokaListView()
    }
}
