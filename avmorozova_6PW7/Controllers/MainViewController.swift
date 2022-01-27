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
    
    private let buttonsStack: UIStackView = {
        let buttonsStack = UIStackView()
        
        buttonsStack.distribution = .fillProportionally
        buttonsStack.spacing = 10
        
        return buttonsStack
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
    
    private func configureUI() {
        configureMap()
        configureButtons()
        configureTextField(textField: startLocation)
        configureTextField(textField: endLocation)
        configureTextStack()
    }
    
    private func configureMap() {
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        mapView.center = view.center
        view.addSubview(mapView)
    }
    
    private func configureButtons() {
        buttonsStack.frame = CGRect(x: view.frame.size.width/2 - 100, y: view.frame.size.height-40, width: 200, height: 30)
        
        buttonsStack.addArrangedSubview(MapButton(frame: CGRect(x: 0, y: 0, width: 40, height: 20), text: "Go", buttonColor: .blue, textColor: .white))
        buttonsStack.addArrangedSubview(MapButton(frame: CGRect(x: 0, y: 0, width: 40, height: 20), text: "Clear", buttonColor: .black, textColor: .white))
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
