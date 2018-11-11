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
    @IBOutlet weak var avatarImageView: AvatarView?
    
    var child: Child?
    
    func update(child: Child) {
        self.child = child
        
        nameLabel?.text = child.name
        personalNumberLabel?.text = child.personalNumber
        
        if let image = child.image {
            avatarImageView?.image = image
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
