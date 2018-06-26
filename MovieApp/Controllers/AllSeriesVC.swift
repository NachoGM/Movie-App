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

    // MARK: Declare Outlets here
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Declare var
    var serie = [Serie]()
    var seriesInCoreData = coreDataSeries()
    
    // MARK: - Declare LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        jsonSeries()
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
    
    // MARK: Modify Status Bar Color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    // MARK: - Json Series
    func jsonSeries() {
        let apiKey = "b66ffea8276ce576d60df52600822c88"
        let language = "en-US"
        let page = 1
        
        SVProgressHUD.show(withStatus: "Loading Series...")

        Alamofire.request("https://api.themoviedb.org/3/tv/popular?api_key=\(apiKey)&language=\(language)&page=\(page)", method: .post).responseData { response in
            
            debugPrint("All Response Movies Info: \(String(describing: response))")
            
            if((response.result.value != nil)){
                
                let jsonData = JSON(response.result.value!)
                
                if let arrJSON = jsonData["results"].arrayObject {
                    for index in 0...arrJSON.count-1 {
                        let aObject = arrJSON[index] as! [String : Any]
                        let serieObject = Serie(with: aObject)
                        self.serie.append(serieObject)
                    }
                }
                
                SVProgressHUD.dismiss()

                OperationQueue.main.addOperation({
                    self.collectionView.reloadData()
                })
            }
        }
    }
    
    // MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let postURL = self.serie[indexPath.row].poster
        let serieTitle = self.serie[indexPath.row].title

        let imgURL = NSURL(string: baseURL + postURL!)
         
        if imgURL != nil {
            let data = NSData(contentsOf: (imgURL as URL?)!)
            cell.posterSerieImg.image = UIImage(data: data! as Data)
            cell.imgSeriePosterNotFoundLbl.text = ""
            cell.titleSerieLbl?.text = serieTitle

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
        let serie = self.serie[indexPath.row]
        self.goToDetailedVC(title: serie.title, date: serie.date, originalTitle: serie.originalTitle, originalLang: serie.originalLang, overview: serie.overview, popularity: serie.popularity, poster: serie.poster, vote: serie.votes)
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
    
     // MARK: - CoreData Methods
     func loadDataFromCoreData() {
     
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
     
        let context = appDelegate.persistentContainer.viewContext
     
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Series")
        request.returnsObjectsAsFaults = false
     
        do {
            let results = try context.fetch(request)
     
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
     
                    if let serie = result.value(forKey: "titles") as? String {
                        seriesInCoreData.allSeries.append(serie)
                    }
                    if let date = result.value(forKey: "date") as? String {
                        seriesInCoreData.allDates.append(date)
                    }
                    if let poster = result.value(forKey: "poster") as? String {
                        seriesInCoreData.allPosters.append(poster)
                    }
                    if let popularity = result.value(forKey: "popularity") as? Double {
                        seriesInCoreData.allPopularities.append(popularity)
                    }
                    if let oLanguages = result.value(forKey: "olanguage") as? String {
                        seriesInCoreData.allOLanguages.append(oLanguages)
                    }
                    if let id = result.value(forKey: "id") as? Int32 {
                        seriesInCoreData.allIds.append(id)
                    }
                    if let overview = result.value(forKey: "overview") as? String {
                        seriesInCoreData.allOverviews.append(overview)
                    }
                    if let oTitles = result.value(forKey: "otitles") as? String {
                        seriesInCoreData.allOSeries.append(oTitles)
                    }
                }
                
                let detailedView = self.storyboard?.instantiateViewController(withIdentifier: "SeriesCheckedVC") as! SeriesCheckedVC
                self.present(detailedView, animated: true, completion: nil)
     
            } else {
                displayMyAlertMessage(userMessage: "You must search any TV Serie or if you prefer you can search it as well")
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
                        
                        switch response.response?.statusCode {
                        case 200:
                            if response.result.value != nil {
                                let jsonData = JSON(response.result.value!)
                                let id = jsonData["results"][0]["id"].int32 ?? 0
                                let title = jsonData["results"][0]["name"].string ?? ""
                                let originalTitle = jsonData["results"][0]["original_name"].string ?? ""
                                let popularity = jsonData["results"][0]["popularity"].double ?? 0.0
                                let poster = jsonData["results"][0]["poster_path"].string ?? ""
                                let originalLang = jsonData["results"][0]["original_language"].string ?? ""
                                let overview = jsonData["results"][0]["overview"].string ?? ""
                                let date = jsonData["results"][0]["first_air_date"].string ?? ""
                                let vote = jsonData["results"][0]["vote_average"].double ?? 0.0
                                
                                let serieObject = Serie(id: id, title: title, originalTitle: originalTitle, popularity: popularity, poster: poster, originalLanguage: originalLang, overview: overview, date: date, votes: vote)
                                self.serie.append(serieObject)
                                
                                // Save data in core data
                                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                                self.saveDataInCoreData(context: context, id: id, title: title, date: date, originalTitle: originalTitle, originalLanguage: originalLang, overview: overview, popularity: popularity, poster: poster, vote: vote)
                                
                                // If Movie is finded, show details
                                self.goToDetailedVC(title: title, date: date, originalTitle: originalTitle, originalLang: originalLang, overview: overview, popularity: popularity, poster: poster, vote: vote)
                            }
                        default:
                            self.displayMyAlertMessage(userMessage: "We couldn't find your TV Serie/ This TV Serie is not avaiable")
                            return
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
        
        loadDataFromCoreData()
    }
    

}
