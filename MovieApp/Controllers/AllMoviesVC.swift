//
//  AllMoviesVC.swift
//  MovieApp
//
//  Created by Nacho MAC on 23/10/2017.
//  Copyright © 2017 Nacho MAC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import SVProgressHUD

protocol Utilities {
}

class AllMoviesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Declare Outlets here
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Declare var here
    var movie = [Movie]()
    var moviesInCoreData = coreDataMovies()

    // MARK: - Display LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (currentReachabilityStatus != .notReachable) != true {
            OperationQueue.main.addOperation({
                self.displayMyAlertMessage(userMessage: "You have your wifi disabled. Please turn it on and try it again.")
                return
            })
            NSLog("No internet connexion")
        } else {
            jsonMovies()
            jsonAuthToken()
        }
        
        initCollectionViewMethods()
        collectionView.reloadData()
    }
    
    func initCollectionViewMethods() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: Alert Dialog
    func displayMyAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title:"Ups...", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "Understood", style: UIAlertActionStyle.default, handler: nil);
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil);
    }

    // MARK: JSON AUTH API
    func jsonAuthToken() {
        
        let apiKey = "b66ffea8276ce576d60df52600822c88"
        
        Alamofire.request("https://api.themoviedb.org/3/authentication/token/new?api_key=\(apiKey)", method: .get).responseData { response in
            
            debugPrint("All Response Authorization Token Info: \(String(describing: response))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
            
            let jsonData = JSON(response.result.value!)
            let requestToken = jsonData["request_token"].string
            self.moviesInCoreData.token.append(requestToken!)
            NSLog("REQUEST TOKEN = \(requestToken!)")
            
            UserDefaults.standard.set(requestToken, forKey: "Token")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    // MARK: - Parse JSON MOVIES API
    func jsonMovies() {
        
        let apiKey = "b66ffea8276ce576d60df52600822c88"
        
        SVProgressHUD.show(withStatus: "Loading Movies")

        Alamofire.request("https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)", method: .post).responseData { response in
            
            debugPrint("All Response Movies Info: \(String(describing: response))")

            if((response.result.value != nil)) {
                
                let jsonData = JSON(response.result.value!)
                
                if let arrJSON = jsonData["results"].arrayObject {
                    
                    for index in 0...arrJSON.count-1 {
                        let aObject = arrJSON[index] as! [String: Any]
                        let movieDict = Movie.init(with: aObject)
                        self.movie.append(movieDict)
                    }
                }
                
                SVProgressHUD.dismiss()
                OperationQueue.main.addOperation({
                    self.collectionView.reloadData()
                })
            }
        }
    }
    
    // MARK: Modify Status Bar Color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let postURL = self.movie[indexPath.row].poster
        let movieTitle = self.movie[indexPath.row].title
        let imgURL = NSURL(string: baseURL + postURL!)

        if imgURL != nil {
            let data = NSData(contentsOf: (imgURL as URL?)!)
            cell.posterImg.image = UIImage(data: data! as Data)
            cell.imageNotFoundedLbl.text = ""
            cell.titleMovieLbl?.text = movieTitle
            
            // Customize image
            cell.posterImg.layer.cornerRadius = 10
            cell.posterImg.layer.masksToBounds = true
            cell.posterImg.layer.borderWidth = 2
            cell.posterImg.layer.borderColor = UIColor.orange.cgColor
        } else {
            cell.imageNotFoundedLbl.text = "Poster not founded"
            cell.posterImg.backgroundColor = UIColor.orange
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 1
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
     
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        self.present(detailedView, animated: true, completion: nil)
    }

    // MARK: - CoreData Methods
    func loadDataFromCoreData() {
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
                }
                
                // If everything is fine, go to MoviesCheckedVC
                let detailedView = self.storyboard?.instantiateViewController(withIdentifier: "MoviesCheckedVC") as! MoviesCheckedVC
                self.present(detailedView, animated: true, completion: nil)
                
            } else {
                displayMyAlertMessage(userMessage: "You must check any movie or if you prefere you can search it as well")
                return
            }
            
        } catch {
            print("Error fetching data")
        }
    }
    
    func saveDataInCoreData(context: NSManagedObjectContext, id: Int32, title: String, date: String, originalTitle: String, originalLanguage: String, overview: String, popularity: Double, poster: String, vote: Double) {
        let movies = Movies(context: context)
        movies.id = id
        movies.date = date
        movies.popularity = popularity
        movies.olanguage = originalLanguage
        movies.otitles = originalTitle
        movies.titles = title
        movies.poster = poster
        movies.overview = overview
        movies.votes = vote
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    // MARK: - Declare Button Actions
    @IBAction func allMoviesCheckedBtn(_ sender: Any) {
        loadDataFromCoreData()
    }
    
    @IBAction func checkMoviesBtn(_ sender: Any) {
        
        let alertController = UIAlertController(title: "All the best movies", message: "Search your Movie here", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Search it!", style: .default, handler: {
            alert -> Void in
            
            let titleMovie = alertController.textFields![0] as UITextField
            NSLog("Movie Searched \(String(describing: titleMovie.text!))")
            
            let apiKey = "b66ffea8276ce576d60df52600822c88"
            let language = "en-US"
            let page = 1
            let movieName = ("\(titleMovie.text!)").removeWhitespace()
            let adult = false
            
            if !titleMovie.text!.isEmpty == false {

                self.displayMyAlertMessage(userMessage: "Please, write the Movie name you want to search and try it againg.")
                return;
                
            } else {
                Alamofire.request("https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=\(language)&query=\(movieName)&page=\(page)&include_adult=\(adult)", method: .get)
                    
                    .responseData { response in
                        debugPrint("All Response Search Movie Info: \(String(describing: response))")
                        
                        switch response.response?.statusCode {
                            
                        case 200:
                            if response.result.value != nil {
                                
                                let jsonData = JSON(response.result.value!)
                                
                                let id = jsonData["results"][0]["id"].int32 ?? 0
                                let title = jsonData["results"][0]["title"].string ?? ""
                                let originalTitle = jsonData["results"][0]["original_title"].string ?? ""
                                let popularity = jsonData["results"][0]["popularity"].double ?? 0.0
                                let poster = jsonData["results"][0]["poster_path"].string ?? ""
                                let originalLang = jsonData["results"][0]["original_language"].string ?? ""
                                let overview = jsonData["results"][0]["overview"].string ?? ""
                                let date = jsonData["results"][0]["release_date"].string ?? ""
                                let vote = jsonData["results"][0]["vote_average"].double ?? 0.0
                                
                                let movieObject = Movie(id: id, title: title, originalTitle: originalTitle, popularity: popularity, poster: poster, originalLanguage: originalLang, overview: overview, date: date, votes: vote)
                                self.movie.append(movieObject)
                                
                                // Save data in core data
                                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                                self.saveDataInCoreData(context: context, id: id, title: title, date: date, originalTitle: originalTitle, originalLanguage: originalLang, overview: overview, popularity: popularity, poster: poster, vote: vote)
                                
                                // If Movie is finded, show details
                                self.goToDetailedVC(title: title, date: date, originalTitle: originalTitle, originalLang: originalLang, overview: overview, popularity: popularity, poster: poster, vote: vote)
                            }
                        default:
                            self.displayMyAlertMessage(userMessage: "We couldn't find your movie/ This movie is not avaiable")
                            return
                        }
                    }
                }
        })
        
        let genresAction = UIAlertAction(title: "Search by Genres", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllGenresVC") as! AllGenresVC
            self.present(vc, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            (action : UIAlertAction!) -> Void in
        })

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Write here the movie name"
            textField.textAlignment = NSTextAlignment.center
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(genresAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func goToDetailedVC(title: String, date: String, originalTitle: String, originalLang: String, overview: String, popularity: Double, poster: String, vote: Double) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailedVC") as! MovieDetailedVC
        vc.titleMovie = title
        vc.date = date
        vc.originalTitle = originalTitle
        vc.originalLanguage = originalLang
        vc.overview = overview
        vc.popularity = popularity
        vc.voteAverage = vote
        vc.imageMovie = poster
        self.present(vc, animated: true, completion: nil)
    }
    
}
