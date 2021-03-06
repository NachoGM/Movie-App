//
//  MovieDetailedVC.swift
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

class MovieDetailedVC: UIViewController {
    
    // MARK: - Declare Outlets here
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var originalTitleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var popularityLbl: UILabel!
    @IBOutlet weak var originalLanguageLbl: UILabel!
    @IBOutlet weak var overviewLbl: UILabel!
    @IBOutlet weak var whiteView2: UIView!
    @IBOutlet weak var whiteView1: UIView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var voView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var genreView: UIView!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterNotFoudedLbl: UILabel!
    @IBOutlet weak var baseBlueView: UIView!
    @IBOutlet weak var baseDetailView: UIView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var votesView: UIView!
    @IBOutlet weak var votesLbl: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: Declare var here
    var id:Int32!
    var imageMovie:String!
    var titleMovie:String!
    var popularity:Double!
    var popularity2: String!
    var originalLanguage:String!
    var originalTitle:String!
    var overview:String!
    var date:String!
    var voteAverage:Double!
    
    // MARK: Display LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        customView()
        self.view.reloadInputViews()
    }
    
    func displayDialogMoreInfo(){
        let alert = UIAlertController(title: "More Info", message: "Be a filmaniatic!", preferredStyle: .alert)
        let firstAction = UIAlertAction(title: "Watch Movie", style: .default) { (alert: UIAlertAction!) -> Void in
            self.displayMyAlertMessage(userMessage: "End Trial App")
        }
        
        let secondAction = UIAlertAction(title: "Download Movie", style: .default) { (alert: UIAlertAction!) -> Void in
            self.displayMyAlertMessage(userMessage: "End Trial App")
        }
        
        let thirdAction = UIAlertAction(title: "Back", style: .destructive) { (alert: UIAlertAction!) -> Void in
            NSLog("Back")
            return
        }
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        alert.addAction(thirdAction)
        
        present(alert, animated: true, completion:nil)
    }
    
    // MARK: Customize View 4 baseDetailView
    func customView() {
        whiteView.layer.shadowOpacity = 0.1
        whiteView1.layer.shadowOpacity = 0.1
        whiteView2.layer.shadowOpacity = 0.1
        infoBtn.layer.shadowOpacity = 0.1
        segmentedControl.layer.shadowOpacity = 0.1
        
        whiteView.layer.shadowColor = UIColor.blue.cgColor
        whiteView1.layer.shadowColor = UIColor.blue.cgColor
        whiteView2.layer.shadowColor = UIColor.blue.cgColor
        infoBtn.layer.shadowColor = UIColor.blue.cgColor
        segmentedControl.layer.shadowColor = UIColor.blue.cgColor
        
        whiteView.layer.cornerRadius = 10
        whiteView1.layer.cornerRadius = 10
        whiteView2.layer.cornerRadius = 10
        infoBtn.layer.cornerRadius = 10
        voView.layer.cornerRadius = 40
        dateView.layer.cornerRadius = 40
        genreView.layer.cornerRadius = 40
        votesView.layer.cornerRadius = 40
    }
    
    // MARK: Update Movie Information
    func updateUI() {
        // Update Labels
        self.titleLbl.text = self.titleMovie ?? ""
        self.originalTitleLbl.text = self.originalTitle ?? ""
        self.originalLanguageLbl.text = self.originalLanguage ?? ""
        self.popularityLbl.text = "\(self.popularity!)"
        self.dateLbl.text = self.date ?? ""
        self.overviewLbl.text = self.overview ?? ""
        self.votesLbl.text = "\(self.voteAverage!)"
        
        // Update Image
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let postURL = "\(self.imageMovie!)"
        let imgURL = NSURL(string: "\(baseURL)\(String(describing: postURL))")
        
        if imgURL != nil {
            let data = NSData(contentsOf: (imgURL as URL?)!)
            self.posterImageView.image = UIImage(data: data! as Data)
            self.posterNotFoudedLbl.text = ""
        } else {
            self.posterImageView.backgroundColor = UIColor.purple
            self.posterNotFoudedLbl.text = "No Poster Founded"
        }
    }
    
    // MARK: Modify Status Bar Color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Alert Dialog
    func displayMyAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title:"Ups...", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "Understood", style: UIAlertActionStyle.default, handler: nil);
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil);
    }
    
    // MARK: - Declare Button Actions
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            NSLog("Detailed")
            baseBlueView.isHidden = true
            baseDetailView.isHidden = false
     
        case 1:
            NSLog("Watch")
            baseBlueView.backgroundColor = UIColor.white
            baseDetailView.isHidden = true
            baseBlueView.isHidden = false
            displayDialogMoreInfo()
            return
            
        default:
            view.addSubview(baseDetailView)
            NSLog("Detailed")
            return
        }
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moreInfoBtn(_ sender: Any) {
        displayDialogMoreInfo()
    }
    
}


