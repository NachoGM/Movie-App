//
//  CoreData.swift
//  MovieApp
//
//  Created by Nacho González Miró on 26/6/18.
//  Copyright © 2018 Nacho MAC. All rights reserved.
//

import Foundation
import CoreData

class coreDataMovies {
    var date: [NSManagedObject] = []
    var titles: [NSManagedObject] = []
    var id: [NSManagedObject] = []
    var otitle: [NSManagedObject] = []
    var olanguage: [NSManagedObject] = []
    var popularity: [NSManagedObject] = []
    var poster: [NSManagedObject] = []
    var overview: [NSManagedObject] = []
    var vote: [NSManagedObject] = []
    
    var movies: [Movies] = []
    var dates: [Movies] = []
    var ids: [Movies] = []
    var posterImg: [Movies] = []
    var oMovies: [Movies] = []
    var oLanguages: [Movies] = []
    var overViews: [Movies] = []
    var popularities: [Movies] = []
    var votes: [Movies] = []
    
    var allMovies: [String] = []
    var allDates: [String] = []
    var allIds: [Int32] = []
    var allPosters: [String] = []
    var allOMovies: [String] = []
    var allOLanguages: [String] = []
    var allOverviews: [String] = []
    var allPopularities: [Double] = []
    var allVotes: [Double] = []
    
    var token = String()
}

class coreDataSeries {
    var date: [NSManagedObject] = []
    var titles: [NSManagedObject] = []
    var id: [NSManagedObject] = []
    var otitle: [NSManagedObject] = []
    var olanguage: [NSManagedObject] = []
    var popularity: [NSManagedObject] = []
    var poster: [NSManagedObject] = []
    var overview: [NSManagedObject] = []
    var vote: [NSManagedObject] = []
    var series: [Series] = []
    var dates: [Series] = []
    var ids: [Series] = []
    var posterImg: [Series] = []
    var oSeries: [Series] = []
    var oLanguages: [Series] = []
    var overViews: [Series] = []
    var popularities: [Series] = []
    var votes: [Series] = []
    
    var allSeries: [String] = []
    var allDates: [String] = []
    var allIds: [Int32] = []
    var allPosters: [String] = []
    var allOSeries: [String] = []
    var allOLanguages: [String] = []
    var allOverviews: [String] = []
    var allPopularities: [Double] = []
    var allVotes: [Double] = []
}
