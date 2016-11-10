//
//  ChildGridCell.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-10.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit

class ChildGridCell: UICollectionViewCell {
    
    @IBOutlet weak var personalNumberLabel: UILabel?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var selectedView: UIView?
    var child: Child?
    
    override var isSelected: Bool {
        didSet {
            self.selectedView?.isHidden = !isSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectedView?.isHidden = true

        imageView?.layer.borderWidth = 1
        imageView?.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = imageView {
            imageView.layer.cornerRadius = imageView.bounds.size.width / 2
        }
    }
    
    func setup(child: Child) {
        personalNumberLabel?.text = child.personalNumber
        nameLabel?.text = child.name
        imageView?.image = child.image
        
        self.child = child
    }
}
