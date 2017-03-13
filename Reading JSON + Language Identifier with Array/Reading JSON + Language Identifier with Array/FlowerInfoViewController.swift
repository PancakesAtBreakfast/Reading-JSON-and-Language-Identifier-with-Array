//
//  FlowerInfoViewController.swift
//  Reading JSON + Language Identifier with Array
//
//  Created by Niso on 3/12/17.
//  Copyright © 2017 Niso. All rights reserved.
//

import UIKit

class FlowerInfoViewController: UIViewController {

    @IBOutlet weak var flowerNameLabel: UILabel!
    @IBOutlet weak var flowerImageView: UIImageView!
    @IBOutlet weak var flowerSeasonLabel: UILabel!
    
    var flowerInfoData:NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        flowerNameLabel.text = flowerInfoData.value(forKey: "name") as! String?
        let imageString = flowerInfoData.value(forKey: "image") as! String
        let imageUrl = NSURL(string: imageString) as! URL
        let imageData = NSData(contentsOf: imageUrl) as! Data
        flowerImageView.image = UIImage(data: imageData)
        flowerSeasonLabel.text = flowerInfoData.value(forKey: "season") as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
