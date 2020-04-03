//
//  CommitCell.swift
//  GitHubMobile
//
//  Created by Li on 4/2/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit

class CommitCell: UITableViewCell {
    var repoLabel: UILabel!
    var messageLabel: UILabel!
    var infoLabel: UILabel!
    
    private var offset: CGFloat = 8
    private var height: CGFloat = 25
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        repoLabel = UILabel()
        repoLabel.numberOfLines = 0
        repoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel = UILabel()
        messageLabel.textColor = .systemBlue
        messageLabel.numberOfLines = 3
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        infoLabel = UILabel()
        infoLabel.numberOfLines = 0
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(repoLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([repoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                                    repoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
                                    repoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
                                    messageLabel.leadingAnchor.constraint(equalTo: repoLabel.leadingAnchor),
                                    messageLabel.trailingAnchor.constraint(equalTo: repoLabel.trailingAnchor),
                                    messageLabel.topAnchor.constraint(equalTo: repoLabel.bottomAnchor, constant: 8),
                                    infoLabel.leadingAnchor.constraint(equalTo: repoLabel.leadingAnchor),
                                    infoLabel.trailingAnchor.constraint(equalTo: repoLabel.trailingAnchor),
                                    infoLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
                                    infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
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
