//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Виктория Бадисова on 23.05.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var mapView: MKMapView!
    
    override func loadView() {
        mapView = MKMapView()
        self.view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded it's view.")
    }
}
