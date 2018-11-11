//
//  AvatarView.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2018-11-01.
//  Copyright © 2018 Knut Inge Grosland. All rights reserved.
//

import UIKit

class AvatarView: UIImageView {
    
    @IBInspectable var borderColor: UIColor? = UIColor.white {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1
        layer.borderColor = borderColor?.cgColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.width / 2
    }
}
