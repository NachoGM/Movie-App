//
//  Genres.swift
//  MovieApp
//
//  Created by Nacho González Miró on 26/6/18.
//  Copyright © 2018 Nacho MAC. All rights reserved.
//

import Foundation

struct Genre {
    
    var id: Int32!
    var title: String!
    
    init(with json: [String: Any]) {
        self.id = json[""] as? Int32
        self.title = json[""] as? String
    }
}
