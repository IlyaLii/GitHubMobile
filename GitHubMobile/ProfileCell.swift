//
//  ProfileCell.swift
//  GitHubMobile
//
//  Created by Li on 3/1/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
