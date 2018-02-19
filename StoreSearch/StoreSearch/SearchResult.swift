//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Christian on 2/19/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import Foundation
import UIKit

class SearchResult {
    var name = ""
    var artistName = ""

    init( name: String , artistName: String) {
        self.name = name
        self.artistName = artistName
    }
}
