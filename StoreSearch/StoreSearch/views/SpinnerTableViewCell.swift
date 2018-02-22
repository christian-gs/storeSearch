//
//  spinnerTableViewCell.swift
//  StoreSearch
//
//  Created by Christian on 2/20/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class SpinnerTableViewCell: UITableViewCell {

    var loadingLabel = UILabel()
    var spinnerView = UIActivityIndicatorView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        loadingLabel.textAlignment = .center
        loadingLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.5)

        spinnerView.color = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.5)

        for v in [loadingLabel, spinnerView] as! [UIView] {
            v.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(v)
        }

        NSLayoutConstraint.activate([
            loadingLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loadingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            spinnerView.leadingAnchor.constraint(equalTo: loadingLabel.trailingAnchor, constant: 10),
            spinnerView.centerYAnchor.constraint(equalTo: loadingLabel.centerYAnchor)

            ])
    }

    func startAnimating() {
        spinnerView.startAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
