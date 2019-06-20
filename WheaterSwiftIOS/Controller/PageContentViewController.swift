//
//  PageContentViewController.swift
//  WheaterSwiftIOS
//
//  Created by WSR on 20/06/2019.
//  Copyright © 2019 WSR. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

    
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var wheaterLabel: UILabel!
    @IBOutlet weak var degLabel: UILabel!
    

    var city = ""
    var wheater = ""
    var deg = ""
    var pageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.text = city
        wheaterLabel.text = wheater
        degLabel.text = deg

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
