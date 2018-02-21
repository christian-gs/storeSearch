//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Christian on 2/19/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import Foundation
import UIKit

class ResultArray:Codable {
    var resultCount = 0
    var results = [SearchResult]()
}

class SearchResult:Codable, CustomStringConvertible {
    
    //this will be returned when trying to use this class as a string
    var description: String {
        return "Kind: \(kind ?? ""), Name: \(name), Artist Name: \(artistName), Genre: \(genre)"
    }

    var kind : String?
    var type:String {
        let kind = self.kind ?? "audiobook"
        switch kind {
            case "album": return "Album"
            case "audiobook": return "Audio Book"
            case "book": return "Book"
            case "ebook": return "E-Book"
            case "feature-movie": return "Movie"
            case "music-video": return "Music Video"
            case "podcast": return "Podcast"
            case "software": return "App"
            case "song": return "Song"
            case "tv-episode": return "TV Episode"
            default: break
        }
        return "Unknown"
    }
    
    var trackName : String?
    var collectionName:String?
    var name:String {
        return trackName ?? collectionName ?? ""
    }
    var artistName = " "

    var imageSmall = ""
    var imageLarge = ""
    var trackViewUrl:String?
    var collectionViewUrl:String?
    var storeURL:String {
        return trackViewUrl ?? collectionViewUrl ?? ""
    }

    var currency = ""
    var trackPrice : Double?
    var collectionPrice:Double?
    var itemPrice:Double?
    var price:Double {
        return trackPrice ?? collectionPrice ?? itemPrice ?? 0.0
    }

    var itemGenre:String?
    var bookGenre:[String]?
    var genre:String {
        if let genre = itemGenre {
            return genre
        } else if let genres = bookGenre {
            return genres.joined(separator: ", ")
        }
        return ""
    }

    // used to store data that isnt that isnt named the same as its key in JSON result from server
    enum CodingKeys: String, CodingKey {
        case imageSmall = "artworkUrl60"
        case imageLarge = "artworkUrl100"
        case itemGenre = "primaryGenreName"
        case bookGenre = "genres"
        case itemPrice = "price"
        //items that are named the same must still be listed
        case kind, artistName, currency
        case trackName, trackPrice, trackViewUrl
        case collectionName, collectionViewUrl, collectionPrice
    }

}

