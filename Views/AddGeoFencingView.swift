//
//  AddGeoFencingView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 27/01/2021.
//

import SwiftUI
import MapKit

struct AddGeoFencingView: View {
    
    // this variable is going to store the current center coordinate of
    //the map
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [MKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    @State private var showingEditScreen = false
    @EnvironmentObject var signInWithAppleMager: SignInWithAppleManager
    
    var body: some View {
        ZStack {
            MapView(centerCoordinate: $centerCoordinate, annotations: locations, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails)
                .edgesIgnoringSafeArea(.all)
            Circle()
                .fill(Color.yellow)
                .opacity(0.75)
                .frame(width: 32, height: 32)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        // create a new location
                        let newLocation = MKPointAnnotation()
                        newLocation.coordinate = self.centerCoordinate
                        newLocation.title = "?"
                        newLocation.subtitle = "200"
                        self.locations.append(newLocation)
                        self.selectedPlace = newLocation
                        self.showingEditScreen = true
                        print("Latitude=\(newLocation.coordinate.latitude)")
                        print("Longitude=\(newLocation.coordinate.longitude)")
                        print("Location title=\(newLocation.title ?? "test")")
                        print("Location Subtitle =\(newLocation.subtitle ?? "test")")
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(Color.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.trailing)
                }
            }
        }.alert(isPresented: $showingPlaceDetails) {
            Alert(title: Text(selectedPlace?.title ?? "Unknown"), message: Text(selectedPlace?.subtitle ?? "Missing place information."), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Edit")) {
                self.showingEditScreen = true
            })
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: saveData) {
            if self.selectedPlace != nil {
                EditGeoLocationView(placemark: self.selectedPlace!)
            }
        }
        .onAppear(perform: loadData)
    }
    
    func loadData() {
     // get data from the server TBD
        
    }
    
    func saveData() {
        
        //this what needs to go to a DataBase
        print("Tamanho do Array locations= \(locations.count)")
        print(locations[0].coordinate.latitude)
        print(locations[0].coordinate.longitude)
        print(locations[0].title ?? " ")
        print(locations[0].subtitle ?? " ")
        print("User = \(UserDefaults.standard.string(forKey: signInWithAppleMager.userIdentifierKey)!)")
        print("Device Token: \(AppDelegate.geolokaToken)")
       // print("This is the device Token = \(toke)")
        let url = URL(string: "https://lokagetlocations-uyiltasaia-ew.a.run.app/put_geofencing.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var dataString = "secret=44fdcv8jf3" // starting POST string with a secretWord
        dataString = dataString + "&name=\(locations[0].title ?? " ")"
        dataString = dataString + "&radius=\(locations[0].subtitle ?? " ")"
        dataString = dataString + "&latitude=\(String(locations[0].coordinate.latitude))"
        dataString = dataString + "&longitude=\(String(locations[0].coordinate.longitude))"
        dataString = dataString + "&identifier=\(UserDefaults.standard.string(forKey: signInWithAppleMager.userIdentifierKey)!)"
        dataString = dataString + "&token=\(AppDelegate.geolokaToken)"
        let dataD = dataString.data(using: .utf8) // convert to utf8 string
        do
        {
            let uploadJob = URLSession.shared.uploadTask(with: request, from: dataD)
            {
                data, response, error in
                if error != nil {
                    DispatchQueue.main.async
                    {
                        print("Upload 1")
                    }
                }
                else
                {
                    if let unwrappedData = data {
                        
                        let returnedData = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        print("Return from server = \(returnedData ?? "vasco")")
                        if returnedData == "1"
                        {
                            print("All GOOD")
                            DispatchQueue.main.async
                            {
                                print(alert)
                                print("Upload 2")
                                // senddata.donesenddata = true
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async
                            {
                                print("Upload 3 - All Good")
                                //donesendingdata = true
                                //self.donesenddata = true
                               // self.showconfirmation = true
                                
                            }
                        }
                    }
                }
            }
            uploadJob.resume()
        }
        
        
    }
    
}

struct AddGeoFencingView_Previews: PreviewProvider {
    static var previews: some View {
        AddGeoFencingView()
    }
}
