//
//  ReposCell.swift
//  GitHubMobile
//
//  Created by Li on 3/2/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit

class ReposCell: UITableViewCell {


    var nameLabel: UILabel!
    var updateLabel: UILabel!
    var infoButton: UIButton!
    private let offset: CGFloat = 20
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel = UILabel()
        nameLabel.textColor = .systemBlue
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        contentView.addSubview(nameLabel)
        
        updateLabel = UILabel()
        contentView.addSubview(updateLabel)
        
        infoButton = UIButton(type: .detailDisclosure)
        contentView.addSubview(infoButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLabel.frame = CGRect(x: offset,
                                   y: 64,
                                   width: contentView.frame.width,
                                   height: 25)
        nameLabel.frame = CGRect(x: offset, y: 11, width: contentView.frame.width - 2 * offset - 25, height: 25)
        
        infoButton.frame = CGRect(x: contentView.frame.width - offset - 25, y: 11, width: 25, height: 25)
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

}
