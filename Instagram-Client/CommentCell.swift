//
//  CommentCell.swift
//  Instagram-Client
//
//  Created by Daniel Ajagbusi on 11/20/19.
//  Copyright © 2019 Daniel Ajagbusi. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var usernameLable: UILabel!
    @IBOutlet weak var commentLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
