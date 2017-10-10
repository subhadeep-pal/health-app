//
//  UICustomisedTextView.swift
//  Health App
//
//  Created by Koushik Dutta on 11/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit

extension UITextView {
    func customizeTextView(placeholderText: String, placeholderColor: UIColor, borderWidth: CGFloat, borderColor: UIColor, cornerRadius: CGFloat){
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
        // add UITextView+Placeholder library to get these options
        self.placeholder = placeholderText
        self.placeholderColor = placeholderColor
    }
}
