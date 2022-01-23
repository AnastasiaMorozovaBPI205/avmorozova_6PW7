//
//  ViewController.swift
//  avmorozova_6PW7
//
//  Created by Anastasia on 23.01.2022.
//

import UIKit
import CoreLocation
import MapKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        
        mapView.layer.masksToBounds = true
        mapView.layer.cornerRadius = 5
        mapView.clipsToBounds = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsTraffic = true
        mapView.showsBuildings = true
        mapView.showsUserLocation = true
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        return mapView
    }()

    private func configureUI() {
        mapView.frame = CGRect(x: 10, y: 20, width: view.frame.size.width-20, height: view.frame.size.height-40)
        mapView.center = view.center
        view.addSubview(mapView)
    }
}


