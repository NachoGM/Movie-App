//
//  Jobs.swift
//  MovieApp
//
//  Created by Nacho González Miró on 26/6/18.
//  Copyright © 2018 Nacho MAC. All rights reserved.
//

import Foundation

struct Job {
    
    var department: String!
    var job = [String]()
    
    init(with json: [String: Any]) {
        self.department = json["department"] as? String
        self.job = (json["job_list"] as? [String])!
    }
}
