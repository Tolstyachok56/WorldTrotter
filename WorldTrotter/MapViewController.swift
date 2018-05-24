//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Виктория Бадисова on 23.05.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    var locationButton: UIButton!
    var locationManager: CLLocationManager!
    
    override func loadView() {
        mapView = MKMapView()
        mapView.delegate = self
        self.view = mapView
        
        locationManager = CLLocationManager()
        
        configureSegmentedControl()
        configureLocationButton()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded it's view.")
        
    }
    
    func configureSegmentedControl() {
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged), for: .valueChanged)
        self.view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    func configureLocationButton() {
        locationButton = UIButton()
        locationButton.setImage(UIImage(named: "Location"), for: .normal)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.imageView?.contentMode = .scaleToFill
        locationButton.addTarget(self, action: #selector(showLocation), for: .touchUpInside)
        self.view.addSubview(locationButton)
        
        let trailingConstraint = locationButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        let bottomConstraint = locationButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -25)
        let widthConstraint = NSLayoutConstraint(item: locationButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 60)
        let heightConstraint = NSLayoutConstraint(item: locationButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 60)
        
        trailingConstraint.isActive = true
        bottomConstraint.isActive = true
        widthConstraint.isActive = true
        heightConstraint.isActive = true
    }
    
   @objc func showLocation() {
        locationManager.requestWhenInUseAuthorization()
        mapView.userTrackingMode = .follow
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500), animated: true)
    }
}
