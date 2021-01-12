//
//  CheckNetworkView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 28/12/2020.
//

import SwiftUI

import Network
import SystemConfiguration
import Combine

struct CheckNetworkView: View {
    
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.apple.com")
    @State var internet = false
    
    var body: some View {
        
        VStack {
            Text("")
                        
                
            
        }.onAppear(perform: {
        var flags = SCNetworkReachabilityFlags()
                    SCNetworkReachabilityGetFlags(self.reachability!, &flags)
            if isnetworkOk(with: flags) {
                internet = false
                print("Network available")
            } else {
                
                print("Network is not available")
                internet = true
                
            }
        }
        )
        .alert(isPresented: $internet) {
                    Alert(
                        title: Text("Check Internet connection"),
                        message: Text("Do you want to dismiss the view?")
                    )
                }
    
    }
}

private func isnetworkOk(with flags: SCNetworkReachabilityFlags) -> Bool    {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!needsConnection || canConnectWithoutInteraction)
    }

struct CheckNetworkView_Previews: PreviewProvider {
    static var previews: some View {
        CheckNetworkView()
    }
}

