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
    @State var tabSelection: Tabs = .tab1
    @ObservedObject var done_Single_map = GettingSingleMapData()
    @EnvironmentObject var signInWithAppleMager: SignInWithAppleManager
    
    var body: some View {
        
                RefreshableNavigationView(title: "Pull to refresh", showRefreshView: $showRefreshView, displayMode: .inline, action:{
                    getDevices_by_identifier.identifier = "000156.42f100f369164279a37b77c63f2dab3f.1008"
                    getDevices_by_identifier.fetchdevices()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.showRefreshView = false
                    }
                }){
                    ForEach(getDevices_by_identifier.lokas_ids){ loka in
                        VStack(alignment: .leading){
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
                            Divider()
                        }
                    }
                  }
                
                
                //jjj
            
        
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
