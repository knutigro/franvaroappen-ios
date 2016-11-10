//
//  ChildCell.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-10.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit

class ChildCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var personalNumberLabel: UILabel?
    @IBOutlet weak var avatarImageView: UIImageView?
    
    var child: Child?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let imageView = avatarImageView {
            imageView.layer.cornerRadius = imageView.bounds.size.width / 2
        }
        
        avatarImageView?.layer.borderWidth = 1
        avatarImageView?.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func update(child: Child) {
        self.child = child
        
        nameLabel?.text = child.name
        personalNumberLabel?.text = child.personalNumber
        avatarImageView?.image = child.image
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
