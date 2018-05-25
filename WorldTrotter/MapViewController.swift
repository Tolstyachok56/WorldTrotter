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
    
    var places: [Place] = [
        Place(title: "Saint-Petersburg", coordinate: CLLocationCoordinate2D(latitude: 59.9342802, longitude: 30.3350986)),
        Place(title: "San Francisco", coordinate: CLLocationCoordinate2D(latitude: 37.7749295, longitude: -122.4194155)),
        Place(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9027835, longitude: 12.4963655))
    ]
    var placeIndex = 0
    
    var mapView: MKMapView!
    var locationButton: UIButton!
    var placeButton: UIButton!
    var locationManager: CLLocationManager!
    
    override func loadView() {
        mapView = MKMapView()
        mapView.addAnnotations(places)
        mapView.delegate = self
        self.view = mapView
        
        locationManager = CLLocationManager()
        
        configureSegmentedControl()
        configureUserLocationButton()
        configurePlacesButton()
    }
    
    // MARK: - Configure UI
    
    func configureSegmentedControl() {
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        
        let segmentedControl = UISegmentedControl(items: [standardString, hybridString, satelliteString])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged), for: .valueChanged)
        self.view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        activateConstraints([topConstraint, leadingConstraint, trailingConstraint])
    }
    

    
    func configureUserLocationButton() {
        locationButton = UIButton()
        setButtonWithParameters(button: locationButton, iconName: "Location", targetSelector: #selector(showUserLocation))

        let trailingConstraint = locationButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        let bottomConstraint = locationButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -25)
        let widthConstraint = NSLayoutConstraint(item: locationButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 60)
        let heightConstraint = NSLayoutConstraint(item: locationButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 60)
        
        activateConstraints([trailingConstraint, bottomConstraint, widthConstraint, heightConstraint])
    }
    
    func configurePlacesButton() {
        placeButton = UIButton()
        setButtonWithParameters(button: placeButton, iconName: "Places", targetSelector: #selector(showPlaceLocation))
        
        let trailingConstraint = placeButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        let bottomConstraint = placeButton.bottomAnchor.constraint(equalTo: locationButton.topAnchor, constant: -10)
        let widthConstraint = NSLayoutConstraint(item: placeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 60)
        let heightConstraint = NSLayoutConstraint(item: placeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 60)
        
        activateConstraints([trailingConstraint, bottomConstraint, widthConstraint, heightConstraint])
    }

    func setButtonWithParameters(button: UIButton, iconName: String, targetSelector selector: Selector) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: iconName), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: selector, for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    func activateConstraints(_ constraints: [NSLayoutConstraint]) {
        if !constraints.isEmpty {
            for constraint in constraints {
                constraint.isActive = true
            }
        }
    }
    
    //MARK: - Selectors
    
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
    
    @objc func showUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        mapView.userTrackingMode = .follow
    }
    
    @objc func showPlaceLocation() {
        if !places.isEmpty {
            let annotation = places[placeIndex]
            mapView.setRegion(MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000), animated: true)
            placeIndex += 1
            if placeIndex == places.count {
                placeIndex = 0
            }
        }
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500), animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        switch annotation {
        case is MKUserLocation:
            pinAnnotationView.pinTintColor = MKPinAnnotationView.greenPinColor()
        case is Place:
            pinAnnotationView.pinTintColor = MKPinAnnotationView.purplePinColor()
        default:
            break
        }
        return pinAnnotationView
    }
    
}

class Place: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
