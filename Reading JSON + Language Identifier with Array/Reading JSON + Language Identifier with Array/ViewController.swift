//
//  ViewController.swift
//  Reading JSON + Language Identifier with Array
//
//  Created by Niso on 3/7/17.
//  Copyright © 2017 Niso. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var dataList:NSArray!
    var selectedCellNumberFromDataList:NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readJSON()
    }
    
    func readJSON(){
        
        let languageId = NSLocale.current.languageCode!
        let jsonFile:String!
        let jsonData:Data!
        
        // Checks if the device's language is not English
        if languageId != "en"{
            // If it's not English we'll use languageData json file
            jsonFile = Bundle.main.path(forResource: "languageData", ofType: "json")
            jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonFile!))
            
            do {
                let readableJSON = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                // translate to dictionary
                let translateDict = readableJSON["translate to"] as! NSDictionary
                // Language dictionary according to languageId
                let languageDict = translateDict[languageId] as! NSDictionary
                self.dataList = languageDict["data"] as! NSArray
                print(self.dataList)
                
            }catch{
                print("Error reading json file")
            }
            
        }else {
            // If it's English we'll use flowersData json file
            jsonFile = Bundle.main.path(forResource: "flowersData", ofType: "json")
            jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonFile!))
            
            do {
                let readableJSON = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                self.dataList = readableJSON["data"] as! NSArray
                print(self.dataList)
                
            }catch{
                print("Error reading json file")
            }
            
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataList != nil{
            return dataList.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = dataList[indexPath.row] as! NSDictionary
        cell.textLabel?.text = item.value(forKey: "name") as! String?
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

