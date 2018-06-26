//
//  GenreSelectedVC.swift
//  MovieApp
//
//  Created by Nacho MAC on 23/10/2017.
//  Copyright © 2017 Nacho MAC. All rights reserved.
//
     
import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class GenreSelectedVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Declare Outlets here
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Declare vars
    var id:Int32!
    var genre:String!
    
    
    var movie = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        jsonGenreMoviesSelected()
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

    // MARK: Parse JSON MOVIES API
    func jsonGenreMoviesSelected() {
        
        let apiKey = "b66ffea8276ce576d60df52600822c88"
        let lang = "en-US"
        
        SVProgressHUD.show(withStatus: "Loading \(genre!)...")

         Alamofire.request("https://api.themoviedb.org/3/genre/\(movie)/movies?api_key=\(apiKey)&language=\(lang)&include_adult=false&sort_by=created_at.asc", method: .get).responseData { response in

            debugPrint("All Response Genre Movies Selected Info: \(String(describing: response))")
            
            if((response.result.value != nil)){
                
                let jsonData = JSON(response.result.value!)
                
                if let arrJSON = jsonData["results"].arrayObject {
                    
                    for index in 0...arrJSON.count-1 {
                        let aObject = arrJSON[index] as! [String : Any]
                        let genreObject = Movie(with: aObject)
                        self.movie.append(genreObject)
                    }
                }
                
                SVProgressHUD.dismiss()
                
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    // MARK: TableView Methods:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let movie = self.movie[indexPath.row]
        cell.titleMovieLbl.text = movie.title
        cell.overviewLbl.text = movie.overview
        cell.dateMovieLbl.text = movie.date
        cell.likesMovieLbl.text = "\(movie.popularity)"
        cell.whiteView.layer.cornerRadius = 10
        cell.whiteView.layer.shadowOpacity = 0.1
        cell.whiteView.layer.shadowColor = UIColor.blue.cgColor
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let postURL = self.movie[indexPath.row].poster
        let titlePoster = self.movie[indexPath.row].title
        let imgURL = NSURL(string: baseURL + postURL!)

        if imgURL != nil {
            let data = NSData(contentsOf: (imgURL as URL?)!)
            cell.posterImg.image = UIImage(data: data! as Data)
            cell.titleMovieLbl?.text = titlePoster
        } else {
            cell.posterImg.backgroundColor = UIColor.orange
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = self.movie[indexPath.row]
        let detailedView = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailedVC") as! MovieDetailedVC
        detailedView.titleMovie = movie.title
        detailedView.overview = movie.overview
        detailedView.date = movie.date
        detailedView.popularity = movie.popularity
        detailedView.originalTitle = movie.originalTitle
        detailedView.originalLanguage = movie.originalLang
        detailedView.imageMovie = movie.poster
        detailedView.voteAverage = movie.votes
        present(detailedView, animated: true, completion: nil)
    }
    
    // MARK: - Declare Button Actions
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
