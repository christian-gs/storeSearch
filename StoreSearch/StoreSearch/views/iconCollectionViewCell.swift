//
//  iconCollectionViewCell.swift
//  StoreSearch
//
//  Created by Christian on 2/22/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class iconCollectionViewCell: UICollectionViewCell {

    let iconButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.frame = CGRect(x: contentView.frame.minX, y: contentView.frame.minY, width: 300, height: 300)
        contentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        iconButton.setImage(#imageLiteral(resourceName: "default"), for: .normal)
        iconButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconButton)

        NSLayoutConstraint.activate([
            iconButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        iconButton.setImage(#imageLiteral(resourceName: "default"), for: .normal)
        super.prepareForReuse()
    }
    
}
