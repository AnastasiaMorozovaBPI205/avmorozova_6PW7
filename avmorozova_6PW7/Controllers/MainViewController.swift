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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        
    }
    
    private func disableButton(button: UIButton) {
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
    }
    
    private func enableButton(button: UIButton) {
        button.setTitleColor(.white, for: .disabled)
        button.isEnabled = true
    }
    
    
    @objc func clearButtonWasPressed() {
        startLocation.text = ""
        endLocation.text = ""
        
        disableButton(button: clearButton)
        disableButton(button: goButton)
            
        clearMap()
    }
    
    @objc func goButtonWasPressed() {
        
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if (startLocation.hasText && endLocation.hasText) {
            goButtonWasPressed()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (startLocation.hasText || endLocation.hasText) {
            enableButton(button: clearButton)
        } else {
            disableButton(button: clearButton)
        }
        
        if (startLocation.hasText && endLocation.hasText) {
            enableButton(button: goButton)
        } else {
            disableButton(button: goButton)
        }
    }
}
