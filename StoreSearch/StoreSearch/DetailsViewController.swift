//
//  DetailsViewController.swift
//  StoreSearch
//
//  Created by Christian on 2/21/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    private var searchResult: SearchResult
    private var detailView = UIView()
    private var closeButton =   UIButton()
    private var artworkImageView = UIImageView()
    private var nameLabel = UILabel()
    private var creatorNameLabel = UILabel()
    private var typeTextLabel = UILabel()
    private var typeValueLabel = UILabel()
    private var genreTextLabel = UILabel()
    private var genreValueLabel = UILabel()
    private var priceButton = UIButton()

    init(searchResult: SearchResult) {
        self.searchResult = searchResult
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5043610873)

        detailView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        detailView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailView)

        for v in [closeButton, artworkImageView, nameLabel, creatorNameLabel, typeTextLabel,
                  typeValueLabel, genreTextLabel, genreValueLabel, priceButton] as! [UIView] {
            v.translatesAutoresizingMaskIntoConstraints = false
            detailView.addSubview(v)
        }

        closeButton.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)

        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.text = searchResult.name
        nameLabel.numberOfLines = 0

        creatorNameLabel.text = searchResult.artistName

        typeTextLabel.text = "Type:"
        typeTextLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        typeValueLabel.text = searchResult.type

        genreTextLabel.text = "Genre:"
        genreTextLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        genreValueLabel.text = searchResult.genre

        priceButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        priceButton.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        priceButton.setTitle(" $\(searchResult.price) ", for: .normal)
        priceButton.setBackgroundImage(#imageLiteral(resourceName: "buttonBackground"), for: .normal)

        NSLayoutConstraint.activate([
            detailView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            detailView.widthAnchor.constraint(equalToConstant: (view.frame.size.width/4 * 3) ), // 3/4 of the screen
            detailView.heightAnchor.constraint(equalToConstant: view.frame.size.height/2 ), // 3/4 of the screen

            closeButton.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 10),
            closeButton.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 10),

            artworkImageView.centerXAnchor.constraint(equalTo: detailView.centerXAnchor),
            artworkImageView.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 10),
            artworkImageView.widthAnchor.constraint(equalToConstant: 100),
            artworkImageView.heightAnchor.constraint(equalToConstant: 100),

            nameLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: artworkImageView.bottomAnchor, constant: 20),

            creatorNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            creatorNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),

            typeTextLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            typeTextLabel.topAnchor.constraint(equalTo: creatorNameLabel.bottomAnchor, constant: 10),

            typeValueLabel.leadingAnchor.constraint(equalTo: genreValueLabel.leadingAnchor),
            typeValueLabel.topAnchor.constraint(equalTo: typeTextLabel.topAnchor),

            genreTextLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            genreTextLabel.topAnchor.constraint(equalTo: typeTextLabel.bottomAnchor, constant: 10),

            genreValueLabel.leadingAnchor.constraint(equalTo: genreTextLabel.trailingAnchor, constant: 10),
            genreValueLabel.topAnchor.constraint(equalTo: genreTextLabel.topAnchor),

            priceButton.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -10),
            priceButton.bottomAnchor.constraint(equalTo: detailView.bottomAnchor, constant: -10)
        ])



    }

    @objc func closeView (_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }



}
