//
//  EditGeoLocationView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 27/01/2021.
//

import SwiftUI
import MapKit

struct EditGeoLocationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var placemark: MKPointAnnotation
    
    var body: some View {
         NavigationView {
             Form {
                 Section {
                    HStack {
                        Text("Geofencing Name =")
                        TextField("Place name", text: $placemark.wrappedTitle)
                    }
                    HStack {
                        Text("Radius(m) =")
                        TextField("Radius", text: $placemark.wrappedSubtitle)
                    }
                 }
             }
             .navigationBarTitle("GeoFencing details")
             .navigationBarItems(trailing: Button("Done") {
                 self.presentationMode.wrappedValue.dismiss()
             })
         }
     }
 }

struct EditGeoLocationView_Previews: PreviewProvider {
    static var previews: some View {
        EditGeoLocationView(placemark: MKPointAnnotation.example)
    }
}
