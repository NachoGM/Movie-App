//
//  SeriesCheckedVC.swift
//  MovieApp
//
//  Created by Nacho MAC on 23/10/2017.
//  Copyright © 2017 Nacho MAC. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD

class SeriesCheckedVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARKS: Declare Outlets here
    @IBOutlet weak var tableView: UITableView!
    
    
    // vars 4 Core Data
    var series: [Series] = []
    var dates: [Series] = []
    var ids: [Series] = []
    var posters: [Series] = []
    var oSeries: [Series] = []
    var oLanguages: [Series] = []
    var overviews: [Series] = []
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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }

    
    // MARKS: Modify Status Bar Color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    

     // MARKS: Get data from Core Data
     func getData() {
        
        SVProgressHUD.show(withStatus: "Loading Series checked...")

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
                    
                    if let votes = result.value(forKey: "votes") as? Double {
                        allVotes.append(votes)
                        print("VOTES = \(votes)")
                    }
                }
            }
            SVProgressHUD.dismiss()

        } catch {
            print("Error fetching data")
        }
     }
    
    
    
    // MARKS: TableView Methods:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.allSeries.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        // Cell Info
        cell.titleMovieLbl.text = allSeries[indexPath.row]
        cell.overviewLbl.text = allOverviews[indexPath.row]
        cell.dateMovieLbl.text = allDates[indexPath.row]
        cell.likesMovieLbl.text = "\(allPopularities[indexPath.row])"
        
        // Customice white view
        cell.whiteView.layer.cornerRadius = 10
        cell.whiteView.layer.shadowOpacity = 0.1
        cell.whiteView.layer.shadowColor = UIColor.blue.cgColor
        
        // Get Image
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let postURL = self.allPosters[indexPath.row]
        
        let imgURL = NSURL(string: "\(baseURL)\(postURL)")
        
        if imgURL != nil {
            
            let data = NSData(contentsOf: (imgURL as URL?)!)
            cell.posterImg.image = UIImage(data: data! as Data)
            // Customize image
            cell.posterImg.layer.cornerRadius = 10
            cell.posterImg.layer.masksToBounds = true
            cell.posterImg.layer.borderWidth = 2
            cell.posterImg.layer.borderColor = UIColor.green.cgColor
        } else {
            cell.posterImg.backgroundColor = UIColor.orange
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailedView = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailedVC") as! MovieDetailedVC
        
        detailedView.titleMovie = self.allSeries[indexPath.row]
        detailedView.overview = self.allOverviews[indexPath.row]
        detailedView.date = self.allDates[indexPath.row]
        detailedView.popularity = self.allPopularities[indexPath.row]
        detailedView.originalTitle = self.allOSeries[indexPath.row]
        detailedView.originalLanguage = self.allOLanguages[indexPath.row]
        detailedView.voteAverage = allVotes[indexPath.row]
        detailedView.imageMovie = allPosters[indexPath.row]
        
        present(detailedView, animated: true, completion: nil)
    }
    
    
    // MARKS: Declare Button Actions
    @IBAction func backBtn(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
