//
//  MapindLokasView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 21/12/2020.
//

import SwiftUI
import MapKit

var allLocations1 = [MKPointAnnotation]()
var locations_map: [CLLocationCoordinate2D] = []
var destination:  [CLLocationCoordinate2D] = []
var allLocations = [MKPointAnnotation]()


class MyAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    init(coordinate: CLLocationCoordinate2D) {
        
        self.coordinate = coordinate
    }
    
}


struct MapViewSingleDevice: UIViewRepresentable {
    
  
    var shared_single : GettingSingleMapData
    var time : Int
    var escolha : String
    var raio: Double
    
func makeCoordinator() -> MapViewCoordinator{
            MapViewCoordinator(self)
        }
    
func updateUIView(_ uiView: MKMapView, context: Context) {
        
        
        
        print("map started")
        uiView.removeAnnotations(uiView.annotations)
        uiView.removeOverlays(uiView.overlays)
        locations_map = []
        allLocations = []
        destination = []
        shared_single.doneGettingSingleMapData = true
       // let time_now_24 = Int(NSDate().timeIntervalSince1970)-(time*60*60)
        let url = URL(string: "https://lokagetlocations-uyiltasaia-ew.a.run.app/get_locations_with_double_entry.php?device=\(escolha)&hours=\(time)")!
        URLSession.shared.dataTask(with: url) {(data,response,error) in
            do {
                if let d = data {
                do {
                    let lokas : [loka_result] = try JSONDecoder().decode([loka_result].self, from: d)
                    DispatchQueue.main.async {
                     
                        for locations in lokas {
                            
                            if locations.accuracy <= raio
                            {
                            var mapRegion = MKCoordinateRegion()
                            let mapRegionSpan = 0.2
                            mapRegion.span.latitudeDelta = mapRegionSpan
                            mapRegion.span.longitudeDelta = mapRegionSpan
                            if locations.temperature == nil {
                                    temp = "N/A"
                                }
                            else {
                                temp = String(locations.temperature!)
                                }
                            let destination = CLLocationCoordinate2D(latitude: locations.lat, longitude: locations.lng)
                            mapRegion.center = destination
                            locations_map.append(destination)
                            uiView.setRegion(mapRegion, animated: true)
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = CLLocationCoordinate2D(latitude: locations.lat, longitude: locations.lng)
                           annotation.title = "Date= \(locations.date) - Time = \(locations.time)"
                           let seq_numberString = String(locations.seqNumber)
                                annotation.subtitle = "Message Seq = \(seq_numberString)\nAccuracy = \(locations.accuracy) m \nTemp =  \(temp ) ºC \nGeo =  \(locations.info)"
                            allLocations.append(annotation)
                            let circle = MKCircle(center: destination, radius: Double(locations.accuracy))
                            uiView.addOverlay(circle)
                         }
                    }
                    print("adding lokas to map")
                    uiView.addAnnotations(allLocations as [MKAnnotation])
                    let polyline = MKPolyline(coordinates: locations_map, count: locations_map.count )
                    uiView.addOverlay(polyline,level: .aboveRoads)
                    uiView.delegate = context.coordinator
                    shared_single.doneGettingSingleMapData = false
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
              
    MKMapView(frame: .zero)
              
          }
        
    }



struct MapindLokasView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        MapViewSingleDevice(shared_single: .init(), time:24, escolha:"7B07E7", raio: 100)
    }
}

