//
//  Series.swift
//  MovieApp
//
//  Created by Nacho González Miró on 26/6/18.
//  Copyright © 2018 Nacho MAC. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

struct Serie {
    
    var id: Int32!
    var title: String!
    var originalTitle: String!
    var popularity: Double!
    var poster: String!
    var originalLang: String!
    var overview: String!
    var date: String!
    var votes: Double!
    
    init(with json: [String: Any]) {
        self.id = json["id"] as? Int32
        self.title = json["title"] as? String ?? ""
        self.originalTitle = json["original_title"] as? String ?? ""
        self.popularity = json["popularity"] as? Double
        self.poster = json["poster_path"] as? String ?? ""
        self.originalLang = json["original_language"] as? String ?? ""
        self.overview = json["overview"] as? String ?? ""
        self.date = json["release_date"] as? String ?? ""
        self.votes = json["vote_average"] as? Double
    }
    
    init(id: Int32, title: String, originalTitle: String, popularity: Double, poster: String, originalLanguage: String, overview: String, date: String, votes: Double) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.popularity = popularity
        self.poster = poster
        self.originalLang = originalLanguage
        self.overview = overview
        self.date = date
        self.votes = votes
    }
    
}
