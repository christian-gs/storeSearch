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
    private var hasSearched = false
    private var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        searchBar.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SpinnerTableViewCell.self, forCellReuseIdentifier: "spinnerCell")
        tableView.register(IconTableViewCell.self, forCellReuseIdentifier: "iconCell")

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

        searchBar.becomeFirstResponder()
    }

    // MARK:- HTTP Request methods
    func iTunesURL(searchText: String) -> URL {
        //encode string to a valid url (eg. turn white space into %20 )
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        let urlString = String(format:"https://itunes.apple.com/search?term=%@", encodedText)
        let url = URL(string: urlString)
        return url!
    }

    func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()  //NOTE: ResultArray is an custom object to store the wrapper returned from JSON HTTP Request
            let result = try decoder.decode(ResultArray.self, from:data)
            return result.results
        } catch {
            print("JSON Error: \(error)")
            return [] }
    }

    func showNetworkError() {
        let alert = UIAlertController(title: "Whoops...",
            message: "There was an error accessing the iTunes Store." +
            " Please try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        present(alert, animated: true, completion: nil)
        alert.addAction(action)
    }

    //MARK- TableViewDelegateMethods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if isLoading {
            return 1
        }
        else if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if hasSearched && searchResults.count == 0 {
            return 44
        }

        return 88
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 || isLoading {
            return nil
        } else {
            return indexPath
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: "spinnerCell") as! SpinnerTableViewCell
            cell.loadingLabel.text = "Loading..."
            cell.startAnimating()
            return cell
        } else if searchResults.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell!.textLabel?.text = "Nothing found"
            cell!.textLabel?.textAlignment = .center
            cell!.textLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.5)
            return cell!
        } else {
            let searchResult = searchResults[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "iconCell") as! IconTableViewCell
            cell.nameLabel.text = searchResult.name

            if searchResult.artistName.isEmpty {
                cell.artistLabel.text = "Unkown"
            } else {
                cell.artistLabel.text = String(format: "%@ (%@)", searchResult.artistName, searchResult.type)
            }
            
            return cell
        }
    }

    //MARK- SearchBarDelegateMethods

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()

            isLoading = true
            tableView.reloadData()

            hasSearched = true
            searchResults = []


            let url = self.iTunesURL(searchText: searchBar.text!)
            let session = URLSession.shared

            let dataTask = session.dataTask(with: url, completionHandler : { data, response, error in
                if let error = error {
                    print("Failure! \n \(error)")
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {

                    if let data = data {
                        self.searchResults = self.parse(data: data)
                        self.searchResults.sort {
                            $0.name.localizedStandardCompare( $1.name) == .orderedAscending
                        }
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.tableView.reloadData()
                        }
                        return
                    }
                } else {
                    print("Failure! \n \(response!)")
                }

                // if we didnt return we have a problem and will reset the tableview to be blank and display the error alert
                DispatchQueue.main.async {
                    self.hasSearched = false
                    self.isLoading = false
                    self.tableView.reloadData()
                    self.showNetworkError()
                }
            })
            dataTask.resume()

        }
    }

    //attach search bar to status bar
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return  .topAttached
    }


}

