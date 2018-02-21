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
    private var gradientView = GradientView()
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
    var downloadTask: URLSessionDownloadTask?

    init(searchResult: SearchResult) {
        self.searchResult = searchResult
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        downloadTask?.cancel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        for v in [gradientView, detailView] {
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
        }

        detailView.tintColor = #colorLiteral(red: 0.07843137255, green: 0.6274509804, blue: 0.6274509804, alpha: 1)
        detailView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        detailView.layer.cornerRadius = 10


        for v in [closeButton, artworkImageView, nameLabel, creatorNameLabel, typeTextLabel,
                  typeValueLabel, genreTextLabel, genreValueLabel, priceButton] as! [UIView] {
            v.translatesAutoresizingMaskIntoConstraints = false
            detailView.addSubview(v)
        }

        closeButton.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)

        // Get image
        if let largeURL = URL(string: searchResult.imageLarge) {
            downloadTask = artworkImageView.loadImage(url: largeURL)
        }
        artworkImageView.contentMode = .scaleAspectFit

        nameLabel.text = searchResult.name
        //dynamic text - support accessibility options
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)

        creatorNameLabel.text = searchResult.artistName
        creatorNameLabel.numberOfLines = 0

        typeTextLabel.text = "Type:"
        typeTextLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        typeValueLabel.text = searchResult.type

        genreTextLabel.text = "Genre:"
        genreTextLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        genreValueLabel.text = searchResult.genre

        priceButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        priceButton.setTitleColor(#colorLiteral(red: 0.07843137255, green: 0.6274509804, blue: 0.6274509804, alpha: 1), for: .normal)
        priceButton.setTitle( priceToText(), for: .normal)
        priceButton.setBackgroundImage(#imageLiteral(resourceName: "buttonBackground"), for: .normal)
        priceButton.addTarget(self, action: #selector(openInStore), for: .touchUpInside)

        NSLayoutConstraint.activate([

            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            detailView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            detailView.widthAnchor.constraint(equalToConstant: (view.frame.size.width/4 * 3) ), // 3/4 of the screen
            detailView.heightAnchor.constraint(greaterThanOrEqualToConstant: view.frame.size.height/2),

            closeButton.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 10),
            closeButton.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 10),

            artworkImageView.centerXAnchor.constraint(equalTo: detailView.centerXAnchor),
            artworkImageView.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 30),
            artworkImageView.widthAnchor.constraint(equalToConstant: 120),
            artworkImageView.heightAnchor.constraint(equalToConstant: 120),

            nameLabel.topAnchor.constraint(greaterThanOrEqualTo: artworkImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -10),
            nameLabel.bottomAnchor.constraint(equalTo: creatorNameLabel.topAnchor, constant: -10),

            creatorNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            creatorNameLabel.bottomAnchor.constraint(equalTo: typeTextLabel.topAnchor, constant: -10),

            typeTextLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            typeTextLabel.bottomAnchor.constraint(equalTo: typeValueLabel.bottomAnchor),

            typeValueLabel.leadingAnchor.constraint(equalTo: genreValueLabel.leadingAnchor),
            typeValueLabel.bottomAnchor.constraint(equalTo: genreValueLabel.topAnchor, constant: -10),

            genreTextLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            genreTextLabel.bottomAnchor.constraint(equalTo: genreValueLabel.bottomAnchor),

            genreValueLabel.leadingAnchor.constraint(equalTo: genreTextLabel.trailingAnchor, constant: 10),
            genreValueLabel.bottomAnchor.constraint(equalTo: priceButton.topAnchor, constant: -10),

            priceButton.bottomAnchor.constraint(equalTo: detailView.bottomAnchor, constant: -10),
            priceButton.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -10),
        ])
    }

    func priceToText() -> String {
        // Show price
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = searchResult.currency
        let priceText: String
        if searchResult.price == 0 {
            priceText = " Free "
        } else if let text = formatter.string(
            from: searchResult.price as NSNumber) {
            priceText = " " + text + " "
        } else {
            priceText = ""
        }
        return priceText
    }

    @objc func closeView (_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @objc func openInStore() {
        if let url = URL(string: searchResult.storeURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }



}
