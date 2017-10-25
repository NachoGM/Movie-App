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
    
    
    var departmentArray: [String] = []
    //var jobsArray: [String] = []
    var jobsArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        jsonJobs()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    
    // MARKS: Modify Status Bar Color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    

    // MARKS: JSON Jobs
    func jsonJobs() {
        
        SVProgressHUD.show(withStatus: "Loading Jobs...")
        
        let apiKey = "b66ffea8276ce576d60df52600822c88"

        Alamofire.request("https://api.themoviedb.org/3/job/list?api_key=\(apiKey)", method: .get).responseData { response in
            
            debugPrint("All Response Jobs Info: \(String(describing: response))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                
                // original server data as UTF8 string
                print("Data: \(utf8Text)")
            }
            
            if((response.result.value != nil)){
                let jsonData = JSON(response.result.value!)
                
                if let arrJSON = jsonData["jobs"].arrayObject {
                    for index in 0...arrJSON.count-1 {
                        
                        let aObject = arrJSON[index] as! [String : AnyObject]
                        
                        let department = aObject["department"] as? String;
                        self.departmentArray.append(department!)
                        
                        let jobs = jsonData["jobs"][0]["job_list"].arrayObject
                        self.jobsArray.append("\(jobs!)")

                        // Print in terminal
                        print("RESPONSE: DEPARTMENTS = \(department!)")
                        print("RESPONSE: JOBS = \(jobs!)")
                    }
                }
                
                
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                })
            }
        }
        SVProgressHUD.dismiss()
    }
    
      
    // MARKS: Generate random color 4 cells
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.departmentArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        // Cell Info
        cell.titleMovieLbl.text = self.departmentArray[indexPath.row]
        cell.titleMovieLbl.textColor = getRandomColor()
        
        cell.jobFlab.text = "\(self.jobsArray[indexPath.row].count)"
        print("EQUAL TO = \(self.jobsArray[indexPath.row].count)")
        //self.jobsArray.count
        
        // Customice white view
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
        
        let jobsInDepartments = self.storyboard?.instantiateViewController(withIdentifier: "JobsDetailedVC") as! JobsDetailedVC
        jobsInDepartments.jobs = self.jobsArray[indexPath.row]
        
        self.present(jobsInDepartments, animated: true, completion: nil)
         
        print("DEPARTMENT = \(departmentArray[indexPath.row])")
        print("JOBS = \(jobsArray[indexPath.row])")


    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
