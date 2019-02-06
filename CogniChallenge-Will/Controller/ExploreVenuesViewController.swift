//
//  ExploreVenuesViewController.swift
//  CogniChallenge-Will
//
//  Created by William Leahy on 2/5/19.
//  Copyright © 2019 William Leahy. All rights reserved.
//

import UIKit
import MapKit

class ExploreVenuesViewController: UIViewController {
    
    //MARK: - Maybe use notifications to communicate status if have more time.
    
    //MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Properties
    
    private var venueModel: VenueModel? {
        didSet {
            mapView.removeAnnotations(mapView.annotations)
            
            if let venues = venueModel?.venues {
                mapView.addAnnotations(venues)
            }
        }
    }
    
    private struct mapViewConstants {
        static let annotationId = "VenueAnnotationId"
        static let regionRadius: CLLocationDistance = 10000
    }
    
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupMapView()
        
        if !User.authorizedUser.UserIsLoggedIn {
            showLoginScreen()
        } else {
            fetchVenues()
        }
    }
    
    
    // MARK: Methods
    private func fetchVenues() {
        NetworkManager.sharedInstance.getVenues { [weak self](result) in
            switch result{
            case.success(let venueModel):
                self?.venueModel = venueModel
            case.failure(let error):
                switch error {
                case .tokenInvalid:
                    self?.showLoginScreen()
                default:
                    self?.presentError(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func showLoginScreen() {
        User.authorizedUser.authToken = nil
        
        guard let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginRegister") as? LoginRegisterViewController else {
            fatalError()
        }
        
        self.present(viewController, animated: true) {
            debugPrint("presented login screen")
        }    
    }
    
    private func setupMapView() {
        mapView.showsUserLocation = true
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
}

extension ExploreVenuesViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = mapView.userLocation.location else { return }
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: mapViewConstants.regionRadius,
                                        longitudinalMeters: mapViewConstants.regionRadius)
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        presentError(message: error.localizedDescription)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Venue else {
            return nil
        }
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: mapViewConstants.annotationId) as? MKMarkerAnnotationView {
            annotationView.annotation = annotation
            
            return annotationView
        } else {
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: mapViewConstants.annotationId)
            annotationView.canShowCallout = true
            
            return annotationView
        }
    }
}
