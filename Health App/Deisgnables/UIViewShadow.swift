//
//  UIViewShadow.swift
//  Health App
//
//  Created by Subhadeep Pal on 05/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit

extension UIView {
    func dropShadow(size: CGFloat, x: CGFloat, y: CGFloat, opacity: Float){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: x, height: y)
        self.layer.shadowRadius = size
        self.layer.shadowOpacity = opacity
    }
}
