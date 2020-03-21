//
//  ProfileCell.swift
//  GitHubMobile
//
//  Created by Li on 3/1/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    
    var profileImage: UIImageView!
    var nameLabel: UILabel!
    private let offset: CGFloat = 8
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        profileImage = UIImageView()
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(profileImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImage.frame = CGRect(x: offset, y: offset, width: contentView.frame.height - 2 * offset, height: contentView.frame.height - 2 * offset)
        nameLabel.frame = CGRect(x: contentView.frame.height + offset,
                                 y: contentView.center.y - (contentView.frame.height - 2 * offset) / 2 ,
                                 width: contentView.frame.width - 3 * offset - profileImage.frame.width,
                                 height: contentView.frame.height - 2 * offset)
    }
    
}
