//
//  SettingsCell.swift
//  GitHubMobile
//
//  Created by Li on 3/12/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    var type: SettingsRows! {
        didSet {
            self.textLabel?.text = self.type.rawValue
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
