//
//  ViewController.swift
//  Notice Location
//
//  Created by Khoi Nguyen on 4/14/17.
//  Copyright © 2017 Khoi Nguyen. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    let locationManager = CLLocationManager()
    var location:CLLocationCoordinate2D?
    var mapView:GMSMapView? = nil
    var locationDragged:Bool = false
    var timeScroll:Timer?
    var isShouldUpdate:Bool?
    var isInfoViewVisible:Bool = false
    var fetcher:RestaurantListFetcher = RestaurantListFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mapInit(latitude: 0, longitude: 0)
        getMyLocation()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "CanAccessAPI"), object: nil, queue: nil) { (notification) in
            self.getRestaurants()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isShouldUpdate = true
    }

    // get device location
    func getMyLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    // init the map
    func mapInit(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> Void {
        // Create a GMSCameraPosition that tells the map to display the
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView?.settings.compassButton = true
        mapView?.settings.myLocationButton = true
        mapView?.isMyLocationEnabled = true
        mapView?.delegate = self
        view = mapView
    }
    
    // get restaurants list
    func getRestaurants() {
        if location != nil {
            fetcher.getRestaurantsByLocation(latitude: (location?.latitude)! , longitude: (location?.longitude)!) { (completed) in
                if completed {
                    self.createMarker()
                    self.isShouldUpdate = true
                }
            }
        }
    }
    
    // create marker on map
    func createMarker() {
        self.mapView?.clear()
        for object in fetcher.dataList {
            let restaurant:RestaurantCompact = object as! RestaurantCompact
            let marker:GMSMarker = GMSMarker.init()
            let position:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: (restaurant.restaurantCoordinate?.latitude)!, longitude: (restaurant.restaurantCoordinate?.longitude)!)
            marker.position = position
            marker.icon = UIImage.init(named: "restaurant_icon")
            marker.map = mapView
            marker.userData = restaurant
        }
    }
    
    
    // MARK - CLLocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = manager.location?.coordinate
        if mapView == nil {
            mapInit(latitude: (location?.latitude)!, longitude: (location?.longitude)!)
        } else {
            //process when location change
            //print("changed")
        }
    }
    
    // MARK - GMSMapView Delegate
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let markerView:MarkerView = UIView.fromNib()
        markerView.restaurant = marker.userData as? RestaurantCompact
        markerView.loadData()
        return markerView
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        isShouldUpdate = false
        isInfoViewVisible = true
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let restaurant = marker.userData as! RestaurantCompact
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.restaurantId = restaurant.restaurantId
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        locationDragged = true
    }
    
    func mapView(_ mapView: GMSMapView, didMove gesture: Bool) {
        print("TEST")
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        //print("didChange")
        location = position.target
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if locationDragged == true && isShouldUpdate == true && isInfoViewVisible == false {
            locationDragged = false
            if timeScroll != nil {
                timeScroll?.invalidate()
            }
            timeScroll = Timer.init(timeInterval: 2, target: self, selector: #selector(getRestaurants), userInfo: nil, repeats: false)
            timeScroll?.fire()
        }
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        isShouldUpdate = true
        isInfoViewVisible = false
    }
}

