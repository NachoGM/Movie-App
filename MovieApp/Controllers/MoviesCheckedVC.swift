//
//  MoviesCheckedVC.swift
//  MovieApp
//
//  Created by Nacho MAC on 23/10/2017.
//  Copyright © 2017 Nacho MAC. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD

class MoviesCheckedVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Declare Outlets here
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Declare var here
    var moviesInCoreData = coreDataMovies()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadDataFromCoreData()
        initTableViewMethods()
        tableView.reloadData()
    }

    func initTableViewMethods() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: Modify Status Bar Color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: CoreData Methods
    func loadDataFromCoreData() {
        SVProgressHUD.show(withStatus: "Loading Movies checked")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Movies")
        request.returnsObjectsAsFaults = false
     
        do {
            let results = try context.fetch(request)
     
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
     
                    if let movie = result.value(forKey: "titles") as? String {
                        moviesInCoreData.allMovies.append(movie)
                    }
                    if let date = result.value(forKey: "date") as? String {
                        moviesInCoreData.allDates.append(date)
                    }
                    if let poster = result.value(forKey: "poster") as? String {
                        moviesInCoreData.allPosters.append(poster)
                    }
                    if let popularity = result.value(forKey: "popularity") as? Double {
                        moviesInCoreData.allPopularities.append(popularity)
                    }
                    if let oLanguages = result.value(forKey: "olanguage") as? String {
                        moviesInCoreData.allOLanguages.append(oLanguages)
                    }
                    if let id = result.value(forKey: "id") as? Int32 {
                        moviesInCoreData.allIds.append(id)
                    }
                    if let overview = result.value(forKey: "overview") as? String {
                        moviesInCoreData.allOverviews.append(overview)
                    }
                    if let oTitles = result.value(forKey: "otitles") as? String {
                        moviesInCoreData.allOMovies.append(oTitles)
                    }
                    if let votes = result.value(forKey: "votes") as? Double {
                        moviesInCoreData.allVotes.append(votes)
                    }
                }
            }
            SVProgressHUD.dismiss()
         } catch {
            print("Error fetching data")
        }
    }
    
    // MARK: - TableView Methods:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesInCoreData.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = moviesInCoreData.allMovies[indexPath.row]
        let overview = moviesInCoreData.allOverviews[indexPath.row]
        let date = moviesInCoreData.allDates[indexPath.row]
        let likes = String(moviesInCoreData.allPopularities[indexPath.row])
        return loadMoviesCell(indexPath: indexPath, title: title, overview: overview, date: date, likes: likes)
    }
    
    func loadMoviesCell(indexPath: IndexPath, title: String, overview: String, date: String, likes: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.titleMovieLbl.text = title
        cell.overviewLbl.text = overview
        cell.dateMovieLbl.text = date
        cell.likesMovieLbl.text = likes
        cell.whiteView.layer.cornerRadius = 10
        cell.whiteView.layer.shadowOpacity = 0.1
        cell.whiteView.layer.shadowColor = UIColor.blue.cgColor
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let postURL = self.moviesInCoreData.allPosters[indexPath.row]
        let imgURL = NSURL(string: baseURL + postURL)
        
        if imgURL != nil {
            let data = NSData(contentsOf: (imgURL as URL?)!)
            cell.posterImg.image = UIImage(data: data! as Data)
            cell.posterImg.layer.cornerRadius = 10
            cell.posterImg.layer.masksToBounds = true
            cell.posterImg.layer.borderWidth = 2
            cell.posterImg.layer.borderColor = UIColor.orange.cgColor
        } else {
            cell.posterImg.backgroundColor = UIColor.orange
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailedView = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailedVC") as! MovieDetailedVC
        detailedView.titleMovie = moviesInCoreData.allMovies[indexPath.row]
         detailedView.overview = moviesInCoreData.allOverviews[indexPath.row]
         detailedView.date = moviesInCoreData.allDates[indexPath.row]
         detailedView.popularity = moviesInCoreData.allPopularities[indexPath.row]
         detailedView.originalTitle = moviesInCoreData.allOMovies[indexPath.row]
         detailedView.originalLanguage = moviesInCoreData.allOLanguages[indexPath.row]
         detailedView.voteAverage = moviesInCoreData.allVotes[indexPath.row]
        detailedView.imageMovie = moviesInCoreData.allPosters[indexPath.row]
        present(detailedView, animated: true, completion: nil)
    }
    
    // MARK: - Declare Button Actions
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
