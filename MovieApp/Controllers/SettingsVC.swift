//
//  SettingsVC.swift
//  MovieApp
//
//  Created by Nacho MAC on 24/10/2017.
//  Copyright © 2017 Nacho MAC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import WebKit

class SettingsVC: UIViewController {

    
    // MARKS: Declare Outlets here
    @IBOutlet weak var webView: UIWebView!
    
    
    // MARKS: Declare Vars here
    var token = String()
    var tokenAuth = UserDefaults.standard.string(forKey: "Token")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.tokenAuth!)

        jsonAuth()
    }

      
    // MARKS: Modify Status Bar Color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
   
     
    // MARKS: JSON Auth
    func jsonAuth() {
        
        SVProgressHUD.show(withStatus: "Loading More Info...")
        
        Alamofire.request("https://www.themoviedb.org/authenticate/\(self.tokenAuth!)?redirect_to=http://www.MovieApp.com/approved", method: .get).responseData { response in
            
            debugPrint("All Response Permissions Info: \(String(describing: response))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                
                // original server data as UTF8 string
                print("Data: \(utf8Text)")
                
                // show html code to webView
                let htmlCode = "\(utf8Text)"
                self.webView.loadHTMLString(htmlCode, baseURL: nil)
                self.webView.layer.borderWidth = 10
                self.webView.layer.borderColor = UIColor.white.cgColor
                self.webView.layer.cornerRadius = 10
                self.webView.layer.masksToBounds = true
            }
            SVProgressHUD.dismiss()
        }
    }
    
}
