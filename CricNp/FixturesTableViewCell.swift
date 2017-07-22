//
//  FixturesTableViewCell.swift
//  CricNp
//
//  Created by Rojan on 6/21/2560 BE.
//  Copyright © 2560 Lizan. All rights reserved.
//

import UIKit

class FixturesTableViewCell: UITableViewCell {

    @IBOutlet weak var teamBimageView: UIImageView!
    @IBOutlet weak var teamAimageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
