//
//  VenueViewController+Extensions.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/21/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension VenueViewController: MKMapViewDelegate {
    
    func setMapAnnotation(lat: Double, lon: Double){
        let annotation = MKPointAnnotation()
        let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        annotation.coordinate = coordinates
        let region = MKCoordinateRegionMakeWithDistance(coordinates, 1000, 1000)
        self.venueMap.region = region
        self.venueMap.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
            pinView!.animatesDrop = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
}
