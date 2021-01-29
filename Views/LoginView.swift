//
//  LoginView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 08/01/2021.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @State private var isAlertPresented = false
    @State private var errDescription = ""
    @Environment(\.window) var window: UIWindow?
    @EnvironmentObject var signInWithAppleMager: SignInWithAppleManager
    @State private var signInWithAppleDelgates : SignInWithAppleDelegates! = nil
    
    var body: some View {
        
    
        ZStack {
            Color.gray.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                    SignInWithAppleButton()
                        .frame(width: 280, height: 60)
                        .padding()
                        .onTapGesture {
                            self.showAppleLogin()
                    }.alert(isPresented: $isAlertPresented) {
                        Alert(title: Text("Error"), message: Text(errDescription), dismissButton: .default(Text("Ok"), action: {
                            // set isUserAuthenticated to signed out
                            self.signInWithAppleMager.isUserAuthenticated = .signedOut
                        }))
                }
                
            }
        }
    }
    
    private func showAppleLogin() {
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        performSignIn(using: [request])
        
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
