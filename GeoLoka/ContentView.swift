//
//  ContentView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 08/01/2021.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var signInWithAppleMager: SignInWithAppleManager
   
    
    var body: some View {
        ZStack {
            if signInWithAppleMager.isUserAuthenticated ==
                .undefined {
                 LaunchScreenView()
               // AddDevicesView()
               // LoginView()
            } else if signInWithAppleMager.isUserAuthenticated == .signedOut {
                   LoginView()
            } else if signInWithAppleMager.isUserAuthenticated == .signedIn {
                //MainTabView()
                DeviceListView()
               // lokaListView()
                 //DeviceListView()
            }
        }
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static let signWithAppleManger = SignInWithAppleManager()
    
    
    static var previews: some View {
        ContentView().environmentObject(signWithAppleManger)
            
    }
}
