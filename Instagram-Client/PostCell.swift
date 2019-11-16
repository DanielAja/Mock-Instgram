//
//  PostTableViewCell.swift
//  Instagram-Client
//
//  Created by Daniel Ajagbusi on 11/15/19.
//  Copyright © 2019 Daniel Ajagbusi. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class PostCell: UITableViewCell {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var captionLable: UILabel!
    @IBOutlet weak var usernameLable: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
