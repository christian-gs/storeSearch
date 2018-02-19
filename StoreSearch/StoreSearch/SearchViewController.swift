//
//  ViewController.swift
//  StoreSearch
//
//  Created by Christian on 2/19/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    private var searchBar = UISearchBar()
    private var tableView = UITableView()
    private var searchResults = [SearchResult]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        searchBar.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SubTitleTableViewCell.self, forCellReuseIdentifier: "subTitleCell")

        for v in [searchBar, tableView] as! [UIView]{
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
        }

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    //MARK- TableViewDelegateMethods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subTitleCell")
        let searchResult = searchResults[indexPath.row]
        cell!.textLabel!.text = searchResult.name
        cell!.detailTextLabel!.text = searchResult.artistName

        return cell!
    }

    //MARK- SearchBarDelegateMethods

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchResults = []
        for i in 0...2 {
            let result = SearchResult(name: String(format: "Fake Result %d for", i), artistName: searchBar.text! )
            searchResults.append(result)
        }
        tableView.reloadData()
    }

    //attach search bar to status bar
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

