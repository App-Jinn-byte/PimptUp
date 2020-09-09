//
//  MapsViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 02/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import CoreLocation

protocol getLocaition: class {
    func onsetLocation(location: String, lat: Double ,lng: Double)
}

class MapsViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    var geoCodeAddress: String?
    var delegate:getLocaition?
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 12000
    var previousLocation: CLLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressLabel.text = ""
        submitBtn.layer.cornerRadius = submitBtn.frame.height/6
        submitBtn.clipsToBounds = true
        self.navigationController?.isNavigationBarHidden = false
        checkLocationServices()
        mapView.delegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        // gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
        
        let coordinate = getCenterLocation(for: mapView)
        
        addressLabel.text = getAddress(cordinate: coordinate)
        
        
    }
    
    @IBAction func suubmitBtn(_ sender: Any) {
        if (addressLabel.text == "" || addressLabel.text == nil){
            Constants.Alert(title: "Input Error", message: "Please tap on screen to get Location", controller: self)
            return
        }
        
        self.delegate?.onsetLocation(location: geoCodeAddress!, lat: mapView.centerCoordinate.latitude, lng:mapView.centerCoordinate.longitude)
        self.navigationController?.popViewController(animated: true)
    }
    @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer)
    {
        
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        let cordinate: CLLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        self.mapView.removeAnnotations(self.mapView.annotations)
        mapView.addAnnotation(annotation)
        
        let address = getAddress(cordinate: cordinate)
        addressLabel.text = address
        
    }
    func setAddress(){
        addressLabel.text = geoCodeAddress
    }
    
    func getAddress(cordinate: CLLocation) -> String{
        
        let geoCoder = CLGeocoder()
        
        
        geoCoder.reverseGeocodeLocation(cordinate) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?[0] else {
                //TODO: Show alert informing the user
                return
            }
            print(placemark)
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let name = placemark.name ?? ""
            if name == ""{
                return
            }
            DispatchQueue.main.async {
                self.addressLabel.text = "\(name),\(streetName),\(streetNumber),\(placemark.postalCode ?? ""),\(placemark.locality ?? ""), \(placemark.country ?? "")"
                self.geoCodeAddress = "\(name) \(streetNumber)\(placemark.locality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.country ?? "")"
            }
            
        }
        return geoCodeAddress ?? ""
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
            
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTackingUserLocation()
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            startTackingUserLocation()
            
        @unknown default:
            break
        }
    }
    
    
    func startTackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}


extension MapsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}


extension MapsViewController: MKMapViewDelegate {
    
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 70 else { return }
        self.previousLocation = center
        
        //        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
        //            guard let self = self else { return }
        //
        //            if let _ = error {
        //                //TODO: Show alert informing the user
        //                return
        //            }
        //
        //            guard let placemark = placemarks?.first else {
        //                //TODO: Show alert informing the user
        //                return
        //            }
        //
        //            let streetNumber = placemark.subThoroughfare ?? ""
        //            let streetName = placemark.thoroughfare ?? ""
        //
        //            DispatchQueue.main.async {
        //                self.addressLabel.text = "\(streetNumber) \(streetName)"
        //            }
        //        }
    }
}















