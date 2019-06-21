//
//  WeatherViewController.swift
//  WheaterSwiftIOS
//
//  Created by Admin on 20.06.2019.
//  Copyright © 2019 WSR. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController{

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var viewLeftConstraint: NSLayoutConstraint!
    
    weak var controller: WeatherController?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let weatherPageViewController = segue.destination as? WeatherController {
            weatherPageViewController.weatherDelegate = self
            controller = weatherPageViewController
        }
    }
    

    
    @IBAction func burgerClick(_ sender: Any) {
        controller?.performSegue(withIdentifier: "CityTable", sender: controller)
    }
    
}

extension WeatherViewController: WeatherPageViewControllerDelegate {
    func weatherPageViewController(weatherPageViewController: WeatherController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func weatherPageViewController(weatherPageViewController: WeatherController, didUpdatePageIndex index: Int) {
        let value = pageControl.numberOfPages - 1 - index
        pageControl.currentPage = value 
    }
}
