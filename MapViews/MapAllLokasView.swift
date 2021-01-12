//
//  MapAllLokasView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 09/01/2021.
//

import SwiftUI
import MapKit

var allLocations2 = [MKPointAnnotation]()
var temperatura = [Double]()

struct MapallLokasView: UIViewRepresentable {
    
    var time = 24
    var shared_all : GettingAllMapData
    var identifier : String
    var delta_hours : Int
    
    func updateUIView(_ uiView2: MKMapView, context: Context) {
        
        uiView2.removeAnnotations(uiView2.annotations)
        uiView2.removeAnnotations(allLocations2)
        allLocations2 = []
      shared_all.doneGettingAllMapData = true
      let url = URL(string: "https://lokagetlocations-uyiltasaia-ew.a.run.app/get_locations_new.php?identifier=\(self.identifier)&hours=\(self.delta_hours)")!
        URLSession.shared.dataTask(with: url) {(data,response,error) in
            do {
                if let d = data {
                    do {
                        let lokas : [loka_result] = try JSONDecoder().decode([loka_result].self, from: d)
                        DispatchQueue.main.async
                        {
                            
                            for locations in lokas
                            
                            {
                                
                                if locations.accuracy <= 500
                                {
                                    if locations.temperature == nil {
                                            temp = "N/A"
                                        }
                                    else {
                                        temperatura.append(locations.temperature!)
                                        temp = String(locations.temperature!)
                                        }
                                    let annotation2 = MKPointAnnotation()
                                        annotation2.coordinate = CLLocationCoordinate2D(latitude: locations.lat, longitude: locations.lng)
                                        annotation2.title = "Device = \(locations.device) \(locations.date)"
                                       let seq_numberString = temp
                                        annotation2.subtitle = "Temp = \(seq_numberString)ºC"
                                        
                                        allLocations2.append(annotation2)
                                        
                                        
                                    }
                                
                            }
                            self.shared_all.doneGettingAllMapData = false
                            uiView2.addAnnotations(allLocations2)
                            uiView2.showAnnotations(uiView2.annotations, animated: true)
                        }
                        
                    }
                }else {
                    print("No Data")
                }
            } catch {
                print("Erro", error)
            }
            
        }.resume()
        
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let uiView2 = MKMapView()
        return uiView2
    }
}
        
        
        
        
        
    
 

struct MapallLokasView_Previews: PreviewProvider {
    static var previews: some View {
        MapallLokasView(shared_all: .init(), identifier:"000156.42f100f369164279a37b77c63f2dab3f.1008",delta_hours:48)
    }
}
