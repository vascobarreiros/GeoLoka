//
//  MapViewCoordinateGeoFencing.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 30/01/2021.
//

import Foundation
import MapKit


class MapViewCoordinateGeoFencing: NSObject, MKMapViewDelegate {
   
    var mapViewController: MapViewGeoFencing
    
    init(_ control: MapViewGeoFencing) {
        self.mapViewController = control
    }

// Function to add the Circle Overaly and or the Polyline Overlay
    
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 3
            renderer.lineDashPattern = [0,5]
            return renderer
        }
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.systemYellow.withAlphaComponent(0.20)
            renderer.strokeColor = UIColor.lightGray
            renderer.lineWidth = 2
            return renderer
        }
        return MKPolylineRenderer()
    }
    
   // Function to add my costum symbol to the map
      
      func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
    // Don't want to show a custom image if the annotation is the user's location.
       guard !(annotation is MKUserLocation) else {
            return nil
        }


        
        
        let annotationIdentifier = annotation.title
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier!)

        let detailLabel = UILabel()
        detailLabel.numberOfLines = 6
        detailLabel.textAlignment = .justified
        detailLabel.font = detailLabel.font.withSize(14)
        detailLabel.text = annotation.subtitle as? String
        annotationView.detailCalloutAccessoryView = detailLabel
        annotationView.canShowCallout = true
        
        let car = UIImage(systemName:"car.fill")!.withTintColor(.systemRed)
            let size = CGSize(width: 20, height: 20)
            annotationView.image = UIGraphicsImageRenderer(size:size).image {
                        _ in car.draw(in:CGRect(origin:.zero, size:size))
                    }
        

          return annotationView
      }
    
}
