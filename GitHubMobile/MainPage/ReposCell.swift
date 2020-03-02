//
//  ReposCell.swift
//  GitHubMobile
//
//  Created by Li on 3/2/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit

class ReposCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var privacyLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
