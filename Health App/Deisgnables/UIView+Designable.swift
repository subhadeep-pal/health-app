//
//  UIView+Designable.swift
//  LearningCreatingDesignable
//
//  Created by 01HW934413 on 25/03/16.
//  Copyright © 2016 01HW934413. All rights reser
//

import UIKit

extension UIView {
    
    @IBInspectable
    var borderWdt: CGFloat {
        get{
            return layer.borderWidth
        }
        
        set(newBorderWidth){
            layer.borderWidth = newBorderWidth
        }
    }
    
    @IBInspectable
    var borderClr: UIColor? {
        get{
            return layer.borderColor != nil ? UIColor(cgColor:  layer.borderColor!) : nil
        }
        
        set{
            layer.borderColor = newValue?.cgColor
        }
    }
    
    
    @IBInspectable
    var cornerRad: CGFloat {
        get{
            return layer.cornerRadius
        }
        
        set{
            if !makeCirle {
                layer.cornerRadius = newValue
                layer.masksToBounds = newValue != 0
            }
        }
    }
    
    @IBInspectable
    var makeCirle: Bool {
        get{
            return (layer.cornerRadius == self.frame.height)
        }
        
        set{
            if newValue {
                layer.cornerRadius = self.frame.height < self.frame.width ? (self.frame.height / 2) : (self.frame.width / 2)
                self.cornerRad = layer.cornerRadius
            } else {
                layer.cornerRadius = self.cornerRad
            }
            layer.masksToBounds = true
        }
    }
    
    
    @IBInspectable
    var dropShadow: Bool {
        get {
            return self.dropShadow
        }
        set {
            self.dropShadowOnVIew(size: 3, x: 0, y: 0, opacity: 0.5)
        }
    }
    
    func dropShadowOnVIew(size: CGFloat, x: CGFloat, y: CGFloat, opacity: Float){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: x, height: y)
        self.layer.shadowRadius = size
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
    }
    
    func removeShadow() {
        self.layer.shadowColor = nil
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0
    }
}

