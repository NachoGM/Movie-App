//
//  JobsDetailedVC.swift
//  MovieApp
//
//  Created by Nacho MAC on 24/10/2017.
//  Copyright © 2017 Nacho MAC. All rights reserved.
//

import UIKit

class JobsDetailedVC: UIViewController {
    
    
    // MARKS: Display Outlets here
    @IBOutlet weak var jobsLbl: UITextView!
    @IBOutlet weak var applyBtn: UIButton!
    
     
    // MARKS: Display Vars here
    var jobs: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        jobsLbl.text = "\(jobs!))"
    
        customApplyBtn()
    }

    
    // MARKS: Modify Status Bar Color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    
    // MARKS: Custom Apply Button
    func customApplyBtn() {
        
        applyBtn.layer.cornerRadius = 20
        applyBtn.layer.shadowOpacity = 0.4
        applyBtn.layer.shadowColor = UIColor.gray.cgColor
        applyBtn.layer.shadowRadius = 2.0
    }
    
    
    // MARKS: Alert Dialog
    func displayMyAlertMessage(userMessage: String) {
        
        let myAlert = UIAlertController(title:"Ups...", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "Understood", style: UIAlertActionStyle.default, handler: nil);
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil);
    }
    
    
    
    // MARKS: Display Button Actions
    @IBAction func applyBtn(_ sender: Any) {
        displayMyAlertMessage(userMessage: "End Trial App")
    }


    @IBAction func backBtn(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
