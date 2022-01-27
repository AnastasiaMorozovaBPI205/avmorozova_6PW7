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
    
    private let buttonsStack: UIStackView = {
        let buttonsStack = UIStackView()
        
        buttonsStack.distribution = .fillProportionally
        buttonsStack.spacing = 10
        
        return buttonsStack
    }()
    
    private let clearButton: MapButton = {
        let clearButton = MapButton(frame: CGRect(x: 0, y: 0, width: 40, height: 20), text: "Clear", buttonColor: .black, textColor: .white)
        
        clearButton.addTarget(self, action: #selector(clearButtonWasPressed), for: .touchUpInside)
        
        clearButton.setTitleColor(.gray, for: .disabled)
        clearButton.isEnabled = false
        
        return clearButton
    }()
    
    private let goButton: MapButton = {
        let goButton = MapButton(frame: CGRect(x: 0, y: 0, width: 40, height: 20), text: "Go", buttonColor: .blue, textColor: .white)
        
        goButton.addTarget(self, action: #selector(goButtonWasPressed), for: .touchUpInside)
        
        goButton.setTitleColor(.gray, for: .disabled)
        goButton.isEnabled = false
        
        return goButton
    }()
    
    private let startLocation: UITextField = {
        let textField = UITextField()
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "From",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        return textField
    }()
    
    private let endLocation: UITextField = {
        let textField = UITextField()
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "To",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        return textField
    }()
    
    
    var coordinates: [CLLocationCoordinate2D] = []
    var overlays: [MKOverlay] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    private func configureUI() {
        configureMap()
        configureButtons()
        configureTextField(textField: startLocation)
        configureTextField(textField: endLocation)
        configureTextStack()
    }
    
    private func configureTextField(textField: UITextField) {
        textField.backgroundColor = .black
        textField.textColor = .white
        textField.alpha = 0.7
        textField.layer.cornerRadius = 2
        textField.clipsToBounds = false
        textField.font = .systemFont(ofSize: 15)
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .yes
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
    }
    
    private func configureMap() {
        mapView.delegate = self
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        mapView.center = view.center
        view.addSubview(mapView)
    }
    
    private func configureButtons() {
        buttonsStack.frame = CGRect(x: view.frame.size.width/2 - 100, y: view.frame.size.height-40, width: 200, height: 30)
        
        buttonsStack.addArrangedSubview(clearButton)
        buttonsStack.addArrangedSubview(goButton)
        
        view.addSubview(buttonsStack)
    }
    
    private func configureTextStack() {
        let textStack = UIStackView()
        
        textStack.axis = .vertical
        textStack.spacing = 10
        
        view.addSubview(textStack)
        
        textStack.pin(to: view, [.top: 50, .left: 10, .right: 10])
        
        [startLocation, endLocation].forEach { textField in
            textField.setHeight(to: 40)
            textField.delegate = self
            textStack.addArrangedSubview(textField)
        }
    }
    
    private func clearMap() {
        if self.overlays.count  > 0 {
            self.mapView.removeOverlays(self.overlays)
            self.overlays = []
        }
        
        self.coordinates = []
        
        self.mapView.removeAnnotations(self.mapView.annotations)
    }
    
    private func disableButton(button: UIButton) {
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
    }
    
    private func enableButton(button: UIButton) {
        button.setTitleColor(.white, for: .disabled)
        button.isEnabled = true
    }
    
    private func buildPath() {
        if self.coordinates.count <= 1 {
            return
        }
        
        let directionRequest = MKDirections.Request()
        
        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: self.coordinates.first!))
        directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: self.coordinates.last!))
        
        directionRequest.transportType = .automobile
        
        MKDirections(request: directionRequest).calculate { (response, error) in
            if error == nil {
                if let overlay = response?.routes.first?.polyline {
                    self.overlays.append(overlay)
                    
                    self.mapView.addOverlay(overlay)
                    self.mapView.centerCoordinate = self.coordinates.last!
                    self.mapView.setRegion(MKCoordinateRegion(center: self.coordinates.last!, span: MKCoordinateSpan(latitudeDelta: 0.9, longitudeDelta: 0.9)), animated: true)
                }
            } else {
                print(String(describing: error))
            }
        }
    }
    
    private func getCoordinateFrom(address: String, completion:
                                    @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?)
                                    -> () ) {
        DispatchQueue.global(qos: .background).async {
            CLGeocoder().geocodeAddressString(address) {
                (placemarks, error) in
                if let placemark = placemarks?.first {
                    guard (placemark.location != nil) else {
                        return
                    }
                    
                    let pointCoordinates = placemark.location!.coordinate
                    self.coordinates.append(pointCoordinates)
                    
                    let point = MKPointAnnotation()
                    point.coordinate = pointCoordinates
                    point.title = address
                    if let country = placemark.country {
                        point.subtitle = country
                    }
                    
                    self.mapView.addAnnotation(point)
                } else {
                    print(String(describing: error))
                }
                
                completion(placemarks?.first?.location?.coordinate, error)
            }
        }
    }
    
    
    @objc func clearButtonWasPressed() {
        startLocation.text = ""
        endLocation.text = ""
        
        disableButton(button: clearButton)
        disableButton(button: goButton)
        
        clearMap()
    }
    
    @objc func goButtonWasPressed() {
        guard
            let first = startLocation.text,
            let second = endLocation.text,
            first != second
        else {
            return
        }
        
        clearMap()
        
        let group = DispatchGroup()
        
        group.enter()
        getCoordinateFrom(address: first, completion: { [weak self] coords,_ in
            if let coords = coords {
                self?.coordinates.append(coords)
            }
            
            group.leave()
        })
        
        group.enter()
        getCoordinateFrom(address: second, completion: { [weak self] coords,_ in
            if let coords = coords {
                self?.coordinates.append(coords)
            }
            group.leave()
        })
        
        group.notify(queue: .main) {
            DispatchQueue.main.async { [weak self] in
                self?.buildPath()
            }
        }
    }
}

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKPolyline.self) {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 3
            
            return polylineRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if (startLocation.hasText || endLocation.hasText) {
            goButtonWasPressed()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (startLocation.hasText || endLocation.hasText) {
            enableButton(button: clearButton)
            enableButton(button: goButton)
        } else {
            disableButton(button: clearButton)
            disableButton(button: goButton)
        }
    }
}
