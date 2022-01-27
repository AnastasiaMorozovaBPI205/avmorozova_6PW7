//
//  MapButtons.swift
//  avmorozova_6PW7
//
//  Created by Anastasia on 26.01.2022.
//

import UIKit

class MapButton: UIButton {
    
    init(frame: CGRect, text: String, buttonColor: UIColor, textColor: UIColor) {
        super.init(frame: frame)
        
        setTitle(text, for: .normal)
        setTitleColor(textColor, for: .normal)
        backgroundColor = buttonColor
        
        layer.cornerRadius = frame.height / 3
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
