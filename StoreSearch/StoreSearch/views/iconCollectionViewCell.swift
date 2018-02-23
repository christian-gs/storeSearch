//
//  iconCollectionViewCell.swift
//  StoreSearch
//
//  Created by Christian on 2/22/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class iconCollectionViewCell: UICollectionViewCell {

    let iconImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.frame = CGRect(x: contentView.frame.minX, y: contentView.frame.minY, width: 300, height: 300)
        contentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        iconImageView.image = #imageLiteral(resourceName: "default")
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)

        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        iconImageView.image = #imageLiteral(resourceName: "default")
        super.prepareForReuse()
    }
    
}
