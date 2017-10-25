//
//  AllSeriesVC.swift
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

class AllSeriesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARKS: Declare Outlets here
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // var 4 api
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        jsonSeries()
        
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

    
    // MARKS: Modify Status Bar Color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    // MARKS: Json Series
    func jsonSeries() {
        let apiKey = "b66ffea8276ce576d60df52600822c88"
        let language = "en-US"
        let page = 1
        
        SVProgressHUD.show(withStatus: "Loading Series...")

        Alamofire.request("https://api.themoviedb.org/3/tv/popular?api_key=\(apiKey)&language=\(language)&page=\(page)", method: .post).responseData { response in
            
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
                        
                        let title = aObject["name"] as? String;
                        self.titleArray.append(title!)
                        
                        let originalTitle = aObject["original_name"] as? String;
                        self.originalTitleArray.append(originalTitle!)
                        
                        let popularity = aObject["popularity"] as? Double;
                        self.popularityArray.append(Double(popularity!))
                         
                        let poster = aObject["poster_path"] as? String;
                        self.imageArray.append(poster!)
                         
                        let originalLang = aObject["original_language"] as? String;
                        self.originalLangArray.append(originalLang!)
                        
                        let overview = aObject["overview"] as? String;
                        self.overviewArray.append(overview!)
                        
                        let date = aObject["first_air_date"] as? String;
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
                        print("RESPONSE: VOTE AVERAGE = \(votes!)")
                    }
                }
                
                SVProgressHUD.dismiss()

                OperationQueue.main.addOperation({
                    self.collectionView.reloadData()
                })
            }
        }
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
            cell.posterSerieImg.image = UIImage(data: data! as Data)
            cell.imgSeriePosterNotFoundLbl.text = ""
            cell.titleSerieLbl?.text = self.titleArray[indexPath.row]

            // Customize image
             cell.posterSerieImg.layer.cornerRadius = 10
             cell.posterSerieImg.layer.masksToBounds = true
             cell.posterSerieImg.layer.borderWidth = 2
             cell.posterSerieImg.layer.borderColor = UIColor.green.cgColor

         } else {
            cell.imgSeriePosterNotFoundLbl.text = "Poster not founded"
            cell.posterSerieImg.backgroundColor = UIColor.orange
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
     
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Series")
        request.returnsObjectsAsFaults = false
     
        do {
            let results = try context.fetch(request)
     
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
     
                    if let serie = result.value(forKey: "titles") as? String {
                        allSeries.append(serie)
                        print("TITLE = \(serie)")
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
                        allOSeries.append(oTitles)
                        print("ORIGINAL TITLE = \(oTitles)")
                    }
                }
                
                // If everything is ok, show Detailed View
                let detailedView = self.storyboard?.instantiateViewController(withIdentifier: "SeriesCheckedVC") as! SeriesCheckedVC
                self.present(detailedView, animated: true, completion: nil)
     
            } else {
                // Display dialog
                displayMyAlertMessage(userMessage: "You must search any TV Serie or if you prefer you can search it as well")
                return;
            }
            
        } catch {
            print("Error fetching data")
        }
     
     }
    
    
    // MARKS: Declare Button Actions
    @IBAction func searchSeriesBtn(_ sender: Any) {
        
        let alertController = UIAlertController(title: "All the best TV Series", message: "Search your TV Serie here", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Search", style: .default, handler: {
            alert -> Void in
            
            let titleMovie = alertController.textFields![0] as UITextField
            let apiKey = "b66ffea8276ce576d60df52600822c88"
            let language = "en-US"
            let page = 1
            let serieName = ("\(titleMovie.text!)").replace(string: " ", replacement: "%20")

            if !titleMovie.text!.isEmpty == false {
                
                self.displayMyAlertMessage(userMessage: "Please, write the TV Serie name you want to search and try it againg.")
                return;
                
            } else {
                
                Alamofire.request("https://api.themoviedb.org/3/search/tv?api_key=\(apiKey)&language=\(language)&query=\(serieName)&page=\(page)", method: .get)
                    
                    .responseData { response in
                        
                        debugPrint("All Response Search Serie Info: \(String(describing: response))")
                        
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            
                            // original server data as UTF8 string
                            print("Data: \(utf8Text)")
                        }
                        
                        if response.response?.statusCode != 200 {
                            
                            // Display dialog
                            self.displayMyAlertMessage(userMessage: "We couldn't find your TV Serie/ This TV Serie is not avaiable")
                            return;
                        } else {
                            
                            if((response.result.value != nil)){
                                
                                let jsonData = JSON(response.result.value!)
                                print("JSON DATA = \(jsonData)")
                                
                                let id = jsonData["results"][0]["id"].int32;
                                self.idArray.append(id!)
                                
                                let title = jsonData["results"][0]["name"].string;
                                self.titleArray.append(title!)
                                
                                let originalTitle = jsonData["results"][0]["original_name"].string;
                                self.originalTitleArray.append(originalTitle!)
                                
                                let popularity = jsonData["results"][0]["popularity"].double;
                                self.popularityArray.append(Double(popularity!))
                                
                                let poster = jsonData["results"][0]["poster_path"].string;
                                self.imageArray.append(poster!)
                                
                                let originalLang = jsonData["results"][0]["original_language"].string;
                                self.originalLangArray.append(originalLang!)
                                
                                let overview = jsonData["results"][0]["overview"].string;
                                self.overviewArray.append(overview!)
                                
                                let date = jsonData["results"][0]["first_air_date"].string;
                                self.dateArray.append(date!)
                                
                                let vote = jsonData["results"][0]["vote_average"].double;
                                self.votesArray.append(Double(vote!))
                 
                                // Print response in terminal
                                print("TITLE = \(title!)")
                                print("ORIGINAL TITLE = \(originalTitle!)")
                                print("POPULARITY = \(popularity!)")
                                print("POSTER = \(poster!)")
                                print("ORIGINAL LANGUAGE = \(originalLang!)")
                                print("OVERVIEW = \(overview!)")
                                print("DATE = \(date!)")
                                print("VOTES = \(vote!)")

                                // Save data in core data
                                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                                let serie = Series(context: context)
                                serie.id = id!
                                serie.date = date!
                                serie.popularity = popularity!
                                serie.olanguage = originalLang!
                                serie.otitles = originalTitle!
                                serie.titles = title!
                                serie.poster = poster!
                                serie.overview = overview!
                                serie.votes = vote!
                                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                                
                                // If Movie is finded, show details
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailedVC") as! MovieDetailedVC
                                vc.titleMovie = title!
                                vc.date = date!
                                vc.originalTitle = originalTitle!
                                vc.originalLanguage = originalLang!
                                vc.overview = overview!
                                vc.popularity = popularity!
                                vc.voteAverage = vote!
                                vc.imageMovie = poster!
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                    }
                }
            })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Write here the TV Serie name"
            textField.textAlignment = NSTextAlignment.center
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func allSeriesChecked(_ sender: Any) {
        
        getData()
    }
    

}
