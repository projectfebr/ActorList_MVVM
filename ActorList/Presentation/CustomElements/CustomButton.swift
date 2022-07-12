//
//  CustomButton.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 26.05.2022.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {

    @IBInspectable
    var titleColor: UIColor = .black {
        didSet {
            self.setTitleColor(titleColor, for: .normal)
        }
    }
    
    @IBInspectable
    var title: String = "Войти" {
        didSet {
            self.setTitle(title, for: .normal)
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 6 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var borderColor: CGColor = CGColor.init(red: 5, green: 5, blue: 5, alpha: 1) {
        didSet {
            self.layer.borderColor = borderColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
}
