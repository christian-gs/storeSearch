//
//  ImageTableViewCell.swift
//  StoreSearch
//
//  Created by Christian on 2/20/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class IconTableViewCell: UITableViewCell {

    var iconImageView = UIImageView()
    var nameLabel = UILabel()
    var artistLabel = UILabel()
    var downloadTask: URLSessionDownloadTask?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        iconImageView.image = #imageLiteral(resourceName: "default")
        iconImageView.contentMode = .scaleAspectFit

        //nameLabel.numberOfLines = 0
        artistLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.5)
        artistLabel.numberOfLines = 0
        
        for v in [iconImageView, nameLabel, artistLabel] as! [UIView] {
            v.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(v)
        }

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),

            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor),

            artistLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            artistLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            artistLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),

        ])

        //change color of cell when selected
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectedView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for result: SearchResult) {
        nameLabel.text = result.name

        if result.artistName.isEmpty {
        artistLabel.text = "Unkown"
        } else {
        artistLabel.text = String(format: "%@ (%@)", result.artistName, result.type)
        }

        iconImageView.image = #imageLiteral(resourceName: "default")
        //download image to cells image view
        if let imageURL = URL(string: result.imageSmall) {
            downloadTask = iconImageView.loadImage(url: imageURL)

        }


    }

    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel() // cancel current image download if cell is going to be reused
        downloadTask = nil
    }

    
}
