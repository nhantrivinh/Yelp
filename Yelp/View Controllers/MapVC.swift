//
//  MapVC.swift
//  Yelp
//
//  Created by Jayven Nhan on 2/25/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var centerLocation = CLLocation()
    var business: Business! {
        didSet {
            if let coordinate = business.coordinate {
                let longitude = CLLocationDegrees(coordinate["longitude"] as! Float)
                let latitude = CLLocationDegrees(coordinate["latitude"] as! Float)
                let centerLocation = CLLocation(latitude: latitude, longitude: longitude)
                self.centerLocation = centerLocation
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goToLocation(location: centerLocation)
        print("Coordinates:")
        print(centerLocation)
    }

    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: true)
    }

}
