//
//  RoundedButton.swift
//  CogniChallenge-Will
//
//  Created by William Leahy on 2/5/19.
//  Copyright © 2019 William Leahy. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButtonWithBorder: UIButton {
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            addBorder()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            addBorder()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        round()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        round()
    }
    
    //MARK: Private
    
    private func round() {
        let size = bounds.size
        layer.cornerRadius = min(size.width, size.height) / 2.0
    }
    
    private func addBorder() {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
    
}
