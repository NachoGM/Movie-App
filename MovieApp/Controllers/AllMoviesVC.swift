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
import SystemConfiguration
import SVProgressHUD

protocol Utilities {
}

class AllMoviesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

    // MARKS: Declare Outlets here
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARKS: Declare var here
    // Declare vars 4 API calls
    var idArray = [Int32]()
    var titleArray = [String]()
    var popularityArray = [Double]()
    var imageArray = [String]()
    var originalLangArray = [String]()
    var originalTitleArray = [String]()
    var overviewArray = [String]()
    var nameArray = [String]()
    var dateArray = [String]()
    var votesArray = [Double]()

    
    // Declare vars 4 Core Data
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
    
    var token = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check internet connections
        if (currentReachabilityStatus != .notReachable) != true {
            
            print("No internet connexion")
            
            OperationQueue.main.addOperation({
                self.displayMyAlertMessage(userMessage: "You have your wifi disabled. Please turn it on and try it again.")
                return;
            })
            
        } else {
            jsonMovies()
            jsonAuthToken()
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
    }
    
    
    // MARKS: Alert Dialog
    func displayMyAlertMessage(userMessage: String) {
        
        let myAlert = UIAlertController(title:"Ups...", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "Understood", style: UIAlertActionStyle.default, handler: nil);
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil);
    }
    

    // MARKS:  JSON AUTH API
    func jsonAuthToken() {
        
        let apiKey = "b66ffea8276ce576d60df52600822c88"
        
        Alamofire.request("https://api.themoviedb.org/3/authentication/token/new?api_key=\(apiKey)", method: .get).responseData { response in
            
            debugPrint("All Response Authorization Token Info: \(String(describing: response))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                
                // original server data as UTF8 string
                print("Data: \(utf8Text)")
            }
            // request_token
            let jsonData = JSON(response.result.value!)
            
            let requestToken = jsonData["request_token"].string
            self.token.append(requestToken!)
            print("REQUEST TOKEN = \(requestToken!)")
            
            UserDefaults.standard.set(requestToken, forKey: "Token")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    // MARKS: Parse JSON MOVIES API
    func jsonMovies() {
        
        let apiKey = "b66ffea8276ce576d60df52600822c88"
        
        SVProgressHUD.show(withStatus: "Loading Movies...")

        Alamofire.request("https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)", method: .post).responseData { response in
            
            debugPrint("All Response Movies Info: \(String(describing: response))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                
                // original server data as UTF8 string
                print("Data: \(utf8Text)")
            }
            
            if((response.result.value != nil)){
                
                let jsonData = JSON(response.result.value!)
                
                if let arrJSON = jsonData["results"].arrayObject {
                    for index in 0...arrJSON.count-1 {
                        
                        let aObject = arrJSON[index] as! [String : AnyObject]
                        
                        let id = aObject["id"] as? Int32;
                        self.idArray.append(id!)

                        let title = aObject["title"] as? String;
                        self.titleArray.append(title!)

                        let originalTitle = aObject["original_title"] as? String;
                        self.originalTitleArray.append(originalTitle!)

                        let popularity = aObject["popularity"] as? Double;
                        self.popularityArray.append(Double(popularity!))
                        
                        let poster = aObject["poster_path"] as? String;
                        self.imageArray.append(poster!)
                        
                        let originalLang = aObject["original_language"] as? String;
                        self.originalLangArray.append(originalLang!)
                        
                        let overview = aObject["overview"] as? String;
                        self.overviewArray.append(overview!)
                        
                        let date = aObject["release_date"] as? String;
                        self.dateArray.append(date!)
                        
                        let votes = aObject["vote_average"] as? Double;
                        self.votesArray.append(Double(votes!))

                        // Print in terminal
                         print("RESPONSE: ID = \(id!)")
                         print("RESPONSE: TITLE = \(title!)")
                         print("RESPONSE: ORIGINAL TITLE = \(originalTitle!)")
                         print("RESPONSE: POPULARITY = \(popularity!)")
                         print("RESPONSE: POSTER = \(poster!)")
                         print("RESPONSE: ORIGINAL LANGUAGE = \(originalLang!)")
                         print("RESPONSE: OVERVIEW = \(overview!)")
                         print("RESPONSE: DATE = \(date!)")
                         print("RESPONSE: VOTES = \(votes!)")
                    }
                }
                
                SVProgressHUD.dismiss()
                OperationQueue.main.addOperation({
                    self.collectionView.reloadData()
                })
            }
        }
    }
    
    
    // MARKS: Modify Status Bar Color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    
    // MARKS: CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.imageArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let postURL = self.imageArray[indexPath.row]
       
        let imgURL = NSURL(string: "\(baseURL)\(postURL)")
        
        if imgURL != nil {
            
            let data = NSData(contentsOf: (imgURL as URL?)!)
            cell.posterImg.image = UIImage(data: data! as Data)
            cell.imageNotFoundedLbl.text = ""
            cell.titleMovieLbl?.text = self.titleArray[indexPath.row]
            
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
        
        let detailedView = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailedVC") as! MovieDetailedVC

        detailedView.titleMovie = titleArray[indexPath.row]
        detailedView.overview = overviewArray[indexPath.row]
        detailedView.date = dateArray[indexPath.row]
        detailedView.popularity = popularityArray[indexPath.row]
        detailedView.originalTitle = originalTitleArray[indexPath.row]
        detailedView.originalLanguage = originalLangArray[indexPath.row]
        detailedView.imageMovie = imageArray[indexPath.row]
        detailedView.voteAverage = votesArray[indexPath.row]

        self.present(detailedView, animated: true, completion: nil)
    }

    
    // MARKS: Get data from Core Data
    func getData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Movies")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    
                    if let movie = result.value(forKey: "titles") as? String {
                        allMovies.append(movie)
                        print("TITLE = \(movie)")
                    }
                    
                    if let date = result.value(forKey: "date") as? String {
                        allDates.append(date)
                        print("DATE = \(date)")
                    }
                    
                    if let poster = result.value(forKey: "poster") as? String {
                        allPosters.append(poster)
                        print("POSTER = \(poster)")
                    }
                    
                    if let popularity = result.value(forKey: "popularity") as? Double {
                        allPopularities.append(popularity)
                        print("POPULARITY = \(popularity)")
                    }
                    
                    if let oLanguages = result.value(forKey: "olanguage") as? String {
                        allOLanguages.append(oLanguages)
                        print("ORIGINAL LANGUAGE = \(oLanguages)")
                    }
                    
                    if let id = result.value(forKey: "id") as? Int32 {
                        allIds.append(id)
                        print("ID = \(id)")
                    }
                    
                    if let overview = result.value(forKey: "overview") as? String {
                        allOverviews.append(overview)
                        print("OVERVIEW = \(overview)")
                    }
                    
                    if let oTitles = result.value(forKey: "otitles") as? String {
                        allOMovies.append(oTitles)
                        print("ORIGINAL TITLE = \(oTitles)")
                    }
                }
                
                // If everything is fine, pass to MoviesCheckedVC
                let detailedView = self.storyboard?.instantiateViewController(withIdentifier: "MoviesCheckedVC") as! MoviesCheckedVC
                self.present(detailedView, animated: true, completion: nil)
                
            } else {
                displayMyAlertMessage(userMessage: "You must check any movie or if you prefere you can search it as well")
                return;
            }
            
        } catch {
            print("Error fetching data")
        }
    }
    
    
    // MARKS: Declare Button Actions
    @IBAction func allMoviesCheckedBtn(_ sender: Any) {
        
        getData()
    }
    
    
    @IBAction func checkMoviesBtn(_ sender: Any) {
        
        let alertController = UIAlertController(title: "All the best movies", message: "Search your Movie here", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Search it!", style: .default, handler: {
            alert -> Void in
            
            let titleMovie = alertController.textFields![0] as UITextField
            print("Movie Searched \(String(describing: titleMovie.text!))")
            
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
                        
                        if response.response?.statusCode != 200 {
                            self.displayMyAlertMessage(userMessage: "We couldn't find your movie/ This movie is not avaiable")
                            return;
                            
                        } else {
                           
                            if((response.result.value != nil)){
                                
                                let jsonData = JSON(response.result.value!)
                                
                                let id = jsonData["results"][0]["id"].int32;
                                self.idArray.append(id!)
                                
                                let title = jsonData["results"][0]["title"].string;
                                self.titleArray.append(title!)
                                
                                let originalTitle = jsonData["results"][0]["original_title"].string;
                                self.originalTitleArray.append(originalTitle!)
                                
                                let popularity = jsonData["results"][0]["popularity"].double;
                                self.popularityArray.append(Double(popularity!))
                                
                                let poster = jsonData["results"][0]["poster_path"].string;
                                self.imageArray.append(poster!)
                                
                                let originalLang = jsonData["results"][0]["original_language"].string;
                                self.originalLangArray.append(originalLang!)
                                
                                let overview = jsonData["results"][0]["overview"].string;
                                self.overviewArray.append(overview!)
                                
                                let date = jsonData["results"][0]["release_date"].string;
                                self.dateArray.append(date!)
                                
                                let vote = jsonData["results"][0]["vote_average"].double;
                                self.votesArray.append(vote!)
                                
                                // Save data in core data
                                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                                
                                let movies = Movies(context: context)
                                movies.id = id!
                                movies.date = date!
                                movies.popularity = popularity!
                                movies.olanguage = originalLang!
                                movies.otitles = originalTitle!
                                movies.titles = title!
                                movies.poster = poster!
                                movies.overview = overview!
                                movies.votes = vote!
                                
                                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                                
                                // Print response in terminal
                                print("RESPONSE DETAILED: TITLE = \(title!)")
                                print("RESPONSE DETAILED: ORIGINAL TITLE = \(originalTitle!)")
                                print("RESPONSE DETAILED: POPULARITY = \(popularity!)")
                                print("RESPONSE DETAILED: POSTER = \(poster!)")
                                print("RESPONSE DETAILED: ORIGINAL LANGUAGE = \(originalLang!)")
                                print("RESPONSE DETAILED: OVERVIEW = \(overview!)")
                                print("RESPONSE DETAILED: DATE = \(date!)")
                                
                                // If Movie is finded, show details
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailedVC") as! MovieDetailedVC
                                
                                vc.titleMovie = title!
                                vc.date = date!
                                vc.originalTitle = originalTitle!
                                vc.originalLanguage = originalLang!
                                vc.overview = overview!
                                vc.popularity = popularity!
                                vc.imageMovie = poster!
                                vc.voteAverage = vote!
                                
                                self.present(vc, animated: true, completion: nil)
                            }
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
    
}


// MARKS: Extension 4 delete & replace white spaces
extension String {
    func replace(string:String, replacement:String) -> String {
        
        return self.replacingOccurrences(of: string, with: replacement)
        
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "%20")
    }
}


extension URL {
    static var documentsDirectory: URL {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(
            
            .documentDirectory, .userDomainMask, true).first!
        return try! documentsDirectory.asURL()
    }
    
    static func urlInDocumentsDirectory(with filename: String) -> URL {
        return documentsDirectory.appendingPathComponent(filename)
    }
}


// MARKS: Extension 4 check if internet is avaiable
extension NSObject:Utilities{
    
    
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable   
        }
    }
    
}
