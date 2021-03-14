//
//  MapViewGeoFencing.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 30/01/2021.
//

import SwiftUI
import MapKit


struct MapViewGeoFencing: UIViewRepresentable {
    
   // var shared_Geo : GettingGeoFencingMap
    @EnvironmentObject var signInWithAppleMager: SignInWithAppleManager
    
    func makeCoordinator() -> MapViewCoordinateGeoFencing{
        MapViewCoordinateGeoFencing(self)
            }
      
    func updateUIView(_ uiView: MKMapView, context: Context) {
     
        print("map started")
        uiView.removeAnnotations(uiView.annotations)
        uiView.removeOverlays(uiView.overlays)
        locations_map = []
        allLocations = []
        destination = []
     //   shared_Geo.doneGettingGeoFencingMap = true
        let url = URL(string: "https://lokaiosapp-cnkwoooqra-ew.a.run.app/get_geofencing.php?identifier=\((UserDefaults.standard.string(forKey: signInWithAppleMager.userIdentifierKey)!))")!
               URLSession.shared.dataTask(with: url)
               {(data,response,error) in
                   do {
                       if let d = data {
                           do {
                               let geofences : [GeoFence] = try JSONDecoder().decode([GeoFence].self, from: d)
                               DispatchQueue.main.async {
                                   for geos in geofences {
                                    var mapRegion = MKCoordinateRegion()
                                    let mapRegionSpan = 0.2
                                    mapRegion.span.latitudeDelta = mapRegionSpan
                                    mapRegion.span.longitudeDelta = mapRegionSpan
                                    let latitude = (geos.latitude as NSString).doubleValue
                                    let longitude = (geos.longitude as NSString).doubleValue
                                    let destination = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                    let radius = (geos.radius as NSString).doubleValue
                                    mapRegion.center = destination
                                    locations_map.append(destination)
                                    uiView.setRegion(mapRegion, animated: true)
                                    let annotation = MKPointAnnotation()
                                       annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                       annotation.title = "Name =\(geos.name)"
                                       annotation.subtitle = "Radius = \(geos.radius) m"
                                    allLocations.append(annotation)
                                    let circle = MKCircle(center: destination, radius: radius)
                                    uiView.addOverlay(circle)
                                   }
                               }
                            uiView.addAnnotations(allLocations as [MKAnnotation])
                            uiView.delegate = context.coordinator
                         //   shared_Geo.doneGettingGeoFencingMap = false
                           }
                       }else {
                           print("No Data")
                       }
                   }catch {
                       print("Erro", error)
                   }
               }.resume()
                   
               
               
               
               
              
        

    }
    
 

    
    
    func makeUIView(context: Context) -> MKMapView {
                  
        MKMapView(frame: .zero)
                  
              }
            
        }
    
struct MapViewGeoFencing_Previews: PreviewProvider {
    static var previews: some View {
        MapViewGeoFencing()
    }
}
