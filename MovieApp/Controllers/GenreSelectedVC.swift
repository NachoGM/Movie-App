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
    
    // MARKS: Declare Outlets here
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARKS: Declare vars
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

    var id:Int32!
    var genre:String!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        jsonGenreMoviesSelected()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }

    
    // MARKS: Modify Status Bar Color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }

    
    // MARKS: Parse JSON MOVIES API
    func jsonGenreMoviesSelected() {
        
        let apiKey = "b66ffea8276ce576d60df52600822c88"
        let lang = "en-US"
        
        SVProgressHUD.show(withStatus: "Loading \(genre!)...")

         Alamofire.request("https://api.themoviedb.org/3/genre/\(id!)/movies?api_key=\(apiKey)&language=\(lang)&include_adult=false&sort_by=created_at.asc", method: .get).responseData { response in

            debugPrint("All Response Genre Movies Selected Info: \(String(describing: response))")
            
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
                    }
                }
                
                SVProgressHUD.dismiss()
                
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    
    // MARKS: TableView Methods:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.titleArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        // Cell Info
        cell.titleMovieLbl.text = titleArray[indexPath.row]
        cell.overviewLbl.text = overviewArray[indexPath.row]
        cell.dateMovieLbl.text = dateArray[indexPath.row]
        cell.likesMovieLbl.text = "\(popularityArray[indexPath.row])"
        
        // Customice white view
        cell.whiteView.layer.cornerRadius = 10
        cell.whiteView.layer.shadowOpacity = 0.1
        cell.whiteView.layer.shadowColor = UIColor.blue.cgColor
        
        // Get Image
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let postURL = self.imageArray[indexPath.row]
        
        let imgURL = NSURL(string: "\(baseURL)\(postURL)")
        
        if imgURL != nil {
            
            let data = NSData(contentsOf: (imgURL as URL?)!)
            cell.posterImg.image = UIImage(data: data! as Data)
            cell.titleMovieLbl?.text = self.titleArray[indexPath.row]
            
        } else {
            cell.posterImg.backgroundColor = UIColor.orange
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailedView = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailedVC") as! MovieDetailedVC

        detailedView.titleMovie = titleArray[indexPath.row]
        detailedView.overview = overviewArray[indexPath.row]
        detailedView.date = dateArray[indexPath.row]
        detailedView.popularity = popularityArray[indexPath.row]
        detailedView.originalTitle = originalTitleArray[indexPath.row]
        detailedView.originalLanguage = originalLangArray[indexPath.row]
        detailedView.imageMovie = imageArray[indexPath.row]
        detailedView.voteAverage = votesArray[indexPath.row]
        
        present(detailedView, animated: true, completion: nil)
    }
    
    
    // MARKS: Declare Button Actions
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
