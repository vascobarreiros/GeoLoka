//
//  LaunchScreenView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 08/01/2021.
//

import SwiftUI
import AuthenticationServices

struct LaunchScreenView: View {
    
    
    @State private var isAlertPresented = false
    @State private var errDescription = ""
    @Environment(\.window) var window: UIWindow?
    @EnvironmentObject var signInWithAppleMager: SignInWithAppleManager
    @State private var signInWithAppleDelgates : SignInWithAppleDelegates! = nil
    
    
    
    var body: some View {
        ZStack {
           CheckNetworkView()
            Color
                .black
                .ignoresSafeArea()
            Image("logo").resizable().scaledToFit()
        }.onAppear {
            self.signInWithAppleMager.checkUserAuth { (authState) in
                switch authState {
                case .undefined:
                    print("Auth State: .undefined")
                    self.performExistingAccountSetupFlows()
                case .signedOut:
                    print("Auth State: .signedOut")
                case .signedIn:
                    print("Auth State: .signedIn")
                }
            }
        }.alert(isPresented: $isAlertPresented) {
            Alert(title: Text("Welcome to GeoLoka - Please Sign In using Apple"), dismissButton: .default(Text("Ok"), action: {
                //set isUserAuthenticated to signed out
                self.signInWithAppleMager.isUserAuthenticated = .signedOut
            }))
        }
    }
    
    private func performExistingAccountSetupFlows() {
        #if !targetEnvironment(simulator)
        let requests = [
            ASAuthorizationAppleIDProvider().createRequest(),
            ASAuthorizationPasswordProvider().createRequest()
        ]
        
        performSignIn(using: requests)
        #endif
        
    }
    
    private func performSignIn(using requests: [ASAuthorizationRequest]) {
        
        signInWithAppleDelgates = SignInWithAppleDelegates(window: window, onSignedIn: {
            (result) in
            switch result {
            
            case .success(let userId):
                UserDefaults.standard.set(userId, forKey: signInWithAppleMager.userIdentifierKey)
                self.signInWithAppleMager.isUserAuthenticated = .signedIn
            case .failure(let err):
                self.errDescription = err.localizedDescription
                self.isAlertPresented = true
            }
        })
        let controler = ASAuthorizationController(authorizationRequests: requests)
        controler.delegate = signInWithAppleDelgates
        controler.presentationContextProvider = signInWithAppleDelgates
        
        controler.performRequests()
        
    }
}
    
    

struct LaunchScreenView_Previews: PreviewProvider {
    
    static let signWithAppleManger = SignInWithAppleManager()
    
    static var previews: some View {
        LaunchScreenView().environmentObject(signWithAppleManger)
    }
}
