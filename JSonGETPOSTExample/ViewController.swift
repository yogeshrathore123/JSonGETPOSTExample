//
//  ViewController.swift
//  JSonGETPOSTExample
//
//  Created by Yogesh Rathore on 08/11/17.
//  Copyright © 2017 Sybrant Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblview: UITableView!
    var dictResponse = NSMutableArray()
    var tmpDict = NSMutableDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("aaa \(self.dictResponse)")
    }
    @IBAction func getAction(_ sender: Any) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            return
        }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                print(data)
            
                do{
                    self.dictResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableArray
                    print(self.dictResponse)
                    print(self.dictResponse.count)
                    
                    if self.dictResponse.count != 0 {
                   
                        DispatchQueue.main.async {
                             self.tblview.reloadData()
                        }
                       
                        for address in self.dictResponse
                        {
                            
                           let email = (address as AnyObject).object(forKey: "address")
                            print("add \(String(describing: email))")
                        }
                    }
                    
                    
                
                }catch{
                    print("Catch error=> \(error)")
                }
            }
        }.resume()
    }
    @IBAction func postAction(_ sender: Any) {
        
        let parameter = ["username": "Yogesh", "password": "yogesh123"]
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data{
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }catch{
                    print(error)
                }
                    
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dictResponse.count != 0 {
            return self.dictResponse.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let tempDict = self.dictResponse.object(at: indexPath.row) as! NSMutableDictionary
       
        cell.textLabel?.text = tempDict["name"] as? String
        cell.detailTextLabel?.text = tempDict["email"] as? String
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

