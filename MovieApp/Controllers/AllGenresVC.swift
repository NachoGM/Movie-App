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

    // MARK: Declare Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Declare vars
    var idArray = [Int32]()
    var titleArray = [String]()
    var genre = [Genre]()
    
    // MARK: Declare LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        jsonGenresMovies()
        initCollectionViewMethods()
    }

    func initCollectionViewMethods() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
     // MARK: - Parse JSON GENRES API
     func jsonGenresMovies() {
        let apiKey = "b66ffea8276ce576d60df52600822c88"
        
        SVProgressHUD.show(withStatus: "Loading Genres...")

        Alamofire.request("https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)&language=en-US", method: .get).responseData { response in
     
            debugPrint("All Response Genre Movies Info: \(String(describing: response))")
     
            if((response.result.value != nil)){
     
                let jsonData = JSON(response.result.value!)

                if let arrJSON = jsonData["genres"].arrayObject {
                   
                    for index in 0...arrJSON.count-1 {
     
                        let aObject = arrJSON[index] as! [String : Any]
                        let genreObject = Genre(with: aObject)
                        self.genre.append(genreObject)
                    }
                }
                
                SVProgressHUD.dismiss()

                OperationQueue.main.addOperation({
                    self.collectionView.reloadData()
                })
            }
        }
     } 
       
    // MARK: Generate random color 4 cells
    func getRandomColor() -> UIColor{
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    // MARK: Modify Status Bar Color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK:-  CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genre.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let title = self.genre[indexPath.row].title
        cell.genresLbl.text = title
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
    
    // MARK: - Declare Button Actions
    @IBAction func backBtn(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
