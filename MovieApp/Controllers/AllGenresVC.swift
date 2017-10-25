//
//  AllGenresVC.swift
//  MovieApp
//
//  Created by Nacho MAC on 23/10/2017.
//  Copyright © 2017 Nacho MAC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class AllGenresVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    // MARKS: Declare Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARKS: Declare vars
    var idArray = [Int32]()
    var titleArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        jsonGenresMovies()
        
        collectionView.dataSource = self
        collectionView.delegate = self 
    }

    
     // MARKS: Parse JSON GENRES API
     func jsonGenresMovies() {
        let apiKey = "b66ffea8276ce576d60df52600822c88"
        
        SVProgressHUD.show(withStatus: "Loading Genres...")

        Alamofire.request("https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)&language=en-US", method: .get).responseData { response in
     
            debugPrint("All Response Genre Movies Info: \(String(describing: response))")
     
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                
                // original server data as UTF8 string
                print("Data: \(utf8Text)")
            }
     
            if((response.result.value != nil)){
     
                let jsonData = JSON(response.result.value!)

                if let arrJSON = jsonData["genres"].arrayObject {
                   
                    for index in 0...arrJSON.count-1 {
     
                        let aObject = arrJSON[index] as! [String : AnyObject]
     
                        let id = aObject["id"] as? Int32;
                        self.idArray.append(id!)
     
                        let name = aObject["name"] as? String;
                        self.titleArray.append(name!)
     
                        // Print response in terminal
                        print("RESPONSE: ID = \(id!)")
                        print("RESPONSE: TITLE = \(name!)")
                    }
                }
                
                SVProgressHUD.dismiss()

                OperationQueue.main.addOperation({
                    self.collectionView.reloadData()
                })
            }
        }
     } 
       
     
    // MARKS: Generate random color 4 cells
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    
    // MARKS: Modify Status Bar Color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    
    // MARKS: CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.titleArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.genresLbl.text = titleArray[indexPath.row]
        cell.genreView.backgroundColor = getRandomColor()
        
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
        
        let detailedView = self.storyboard?.instantiateViewController(withIdentifier: "GenreSelectedVC") as! GenreSelectedVC
        
        detailedView.id = idArray[indexPath.row]
        detailedView.genre = titleArray[indexPath.row]

        self.present(detailedView, animated: true, completion: nil)
    }
    
    
    // MARKS: Declare Button Actions
    @IBAction func backBtn(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }


}
