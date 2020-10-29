//
//  RoundButton.swift
//  MyoVis
//
//  Created by Panagiotis Diakas on 29.07.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}

class WhiteBorder: UITextField {
    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = midBlue.cgColor
    }
}

class SignalView: UIView {
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderColor = lightBlue.cgColor
        self.layer.borderWidth = 1.0
    }
}
