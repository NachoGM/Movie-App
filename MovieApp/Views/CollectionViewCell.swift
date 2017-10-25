//
//  CollectionViewCell.swift
//  MovieApp
//
//  Created by Nacho MAC on 23/10/2017.
//  Copyright © 2017 Nacho MAC. All rights reserved.
//

import UIKit
     
class CollectionViewCell: UICollectionViewCell {
    
    // Movies
    @IBOutlet weak var imageNotFoundedLbl: UILabel!
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var titleMovieLbl: UILabel!
    
    // Series
    @IBOutlet weak var imgSeriePosterNotFoundLbl: UILabel!
    @IBOutlet weak var posterSerieImg: UIImageView!
    @IBOutlet weak var titleSerieLbl: UILabel!

    // Genres
    @IBOutlet weak var genreView: UIView!
    @IBOutlet weak var genresLbl: UILabel!
    
}
