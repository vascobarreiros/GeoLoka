//
//  GeoLokaApp.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 08/01/2021.
//

import SwiftUI

@main
struct GeoLokaApp: App {
    
    let signWithAppleManger = SignInWithAppleManager()
   
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(signWithAppleManger)
               
                
        }
    }
}
