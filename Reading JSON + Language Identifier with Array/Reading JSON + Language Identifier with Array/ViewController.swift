//
//  ViewController.swift
//  Reading JSON + Language Identifier with Array
//
//  Created by Niso on 3/7/17.
//  Copyright © 2017 Niso. All rights reserved.
//
//
// JSON file read according to Phone language.
// There are two JSON files that are built in a different format.
// One consists of a dictionary and array, and the other one consists only dictionary.
// Despite the differences in their structure they both use the same array to display the names of the flowers.

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var selectedFlowerData:NSDictionary!
    var translateTo:NSDictionary!
    var languageRegion:NSDictionary!
    var dataList:NSDictionary!
    var flowersData:NSArray!
    var namesArray = [String]()
    
    
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
                translateTo = readableJSON["translate to"] as! NSDictionary
                
                // Language dictionary according to languageId
                languageRegion = translateTo[languageId] as! NSDictionary
                
                // The data of the selected language
                dataList = languageRegion["data"] as! NSDictionary
                
                // The flowers names inserted into array by for loop
                for flower in dataList{
                    let flowerDict  = flower.value as! NSDictionary
                    let name = flowerDict.value(forKey: "name")
                    self.namesArray.append(name as! String)
                    print(namesArray)
                    
                }
            }catch{
                print("Error reading json file")
            }
            
        }else {
            // If it's English we'll use flowersData json file
            jsonFile = Bundle.main.path(forResource: "flowersData", ofType: "json")
            jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonFile!))
            
            do {
                let readableJSON = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                self.flowersData = readableJSON.value(forKey: "data") as? NSArray
                print(flowersData)
                
                // The flowers names inserted into array by for loop
                for flower in flowersData{
                    let flowerDict  = flower as! NSDictionary
                    let flowersName = flowerDict.value(forKey: "name")
                    self.namesArray.append(flowersName as! String)
                    print(namesArray)
                    
                }
                
            }catch{
                print("Error reading json file")
            }
            
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if namesArray.count != 0{
            return namesArray.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = namesArray[indexPath.row] as String
        cell.textLabel?.text = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // If flowersData is NOT empty it means the device's language is English
        if flowersData != nil {
            selectedFlowerData = flowersData.object(at: indexPath.row) as! NSDictionary
            print(selectedFlowerData)
        }else{
            // If the device's language is not English we'll use dataList
            var flowerSelectedData:NSDictionary!
            let flowerSelected = namesArray[indexPath.row]
            for flower in dataList{
                let flowerDict  = flower.value as! NSDictionary
                let name:String = flowerDict.value(forKey: "name") as! String
                if flowerSelected == name {
                    flowerSelectedData = flowerDict
                    print("equal")
                    break
                }else{
                    print("Not equal")
                }
            }
            
            selectedFlowerData = flowerSelectedData
            print(selectedFlowerData)
        }
        
        // Move to the next screen
        performSegue(withIdentifier: "flowerInfoSegue", sender: self)
    }

    // MARK: - Navigation to Flower Info screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "flowerInfoSegue" {
            let flowerInfoScreen = segue.destination as! FlowerInfoViewController
            
            flowerInfoScreen.flowerInfoData = selectedFlowerData
        }
    }


}

