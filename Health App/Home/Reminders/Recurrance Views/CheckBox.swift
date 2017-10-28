//
//  CheckBox.swift
//  Health App
//
//  Created by Subhadeep Pal on 28/10/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit

protocol CheckBoxProtocol {
    func tappedCheckbox(withTag tag: Int)
}

class CheckBox: UIView {
    
    var checkBoxImageView : UIImageView!
    var title : UILabel!
    var titleText : String = "Title Text Not Set"
    
    var isSelected : Bool = false {
        didSet {
            toogleSelection()
        }
    }
    
    var delegate: CheckBoxProtocol?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        for subview in subviews {
            if let imageSubview = subview as? UIImageView {
                checkBoxImageView = imageSubview
            }
            if let label = subview as? UILabel {
                title = label
            }
        }
        
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(tapped(sender:)))
        self.addGestureRecognizer(tapGestureRecogniser)
        self.title.text = titleText
    }
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        isSelected = !isSelected
        self.delegate?.tappedCheckbox(withTag: self.tag)
    }
    
    private func toogleSelection() {
        if isSelected {
            checkBoxImageView.image = #imageLiteral(resourceName: "ic_check_box")
        } else {
            checkBoxImageView.image = #imageLiteral(resourceName: "ic_check_box_outline_blank")
        }
    }
    
    func set(title: String) {
        self.titleText = title
    }

}
