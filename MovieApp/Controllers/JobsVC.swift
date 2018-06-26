//
//  JobsVC.swift
//  MovieApp
//
//  Created by Nacho MAC on 24/10/2017.
//  Copyright © 2017 Nacho MAC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class JobsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var jobs = [Job]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        jsonJobs()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - JSON Jobs
    func jsonJobs() {
        
        SVProgressHUD.show(withStatus: "Loading Jobs...")
        
        let apiKey = "b66ffea8276ce576d60df52600822c88"

        Alamofire.request("https://api.themoviedb.org/3/job/list?api_key=\(apiKey)", method: .get).responseData { response in
            
            debugPrint("All Response Jobs Info: \(String(describing: response))")
            
            if((response.result.value != nil)){
                let jsonData = JSON(response.result.value!)
                
                if let arrJSON = jsonData["jobs"].arrayObject {
                    
                    for index in 0...arrJSON.count-1 {
                        let aObject = arrJSON[index] as! [String : Any]
                        let jobObject = Job(with: aObject)
                        self.jobs.append(jobObject)
                    }
                }
                
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                })
            }
        }
        SVProgressHUD.dismiss()
    }
     
      
    // MARK: Generate random color 4 cells
    func getRandomColor() -> UIColor{
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }

    // MARK: - Display TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let title = jobs[indexPath.row].department
        let numberOfJobs = jobs[indexPath.row].job.count
        cell.titleMovieLbl.text = title
        cell.titleMovieLbl.textColor = getRandomColor()
        
        cell.jobFlab.text = "\(numberOfJobs)"
        
        cell.whiteView.layer.cornerRadius = 20
        cell.whiteView.layer.shadowOpacity = 0.1
        cell.whiteView.layer.shadowColor = UIColor.blue.cgColor
        cell.imgFlag.layer.cornerRadius = 15
        cell.imgFlag.layer.masksToBounds = true
        cell.imgFlag.backgroundColor = UIColor.red
        cell.imgFlag.layer.shadowOpacity = 0.1
        cell.imgFlag.layer.shadowColor = UIColor.gray.cgColor
        cell.imgFlag.layer.shadowRadius = 1
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobsArray = jobs[indexPath.row].job
        let jobsInDepartments = self.storyboard?.instantiateViewController(withIdentifier: "JobsDetailedVC") as! JobsDetailedVC
        jobsInDepartments.jobs = "\(String(describing: jobsArray))"
        self.present(jobsInDepartments, animated: true, completion: nil)

    }
}
