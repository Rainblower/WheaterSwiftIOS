//
//  WeatherController.swift
//  WheaterSwiftIOS
//
//  Created by WSR on 20/06/2019.
//  Copyright © 2019 WSR. All rights reserved.
//

import UIKit

class WeatherController: UIPageViewController, UIPageViewControllerDataSource {
    
    let group = DispatchGroup()
      let mainGroup = DispatchGroup()
    var cities: [OpenWheather] = []
    let saveCities = ["Moscow","Kazan","Omsk","Sankt-peterburg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
     
        for city in saveCities.reversed() {
            
            fetchData(city: city)
            self.mainGroup.wait()
        
        }


        mainGroup.wait()
       
        print(cities.count)
        self.setViewControllers([getViewControllerAtIndex(index: cities.count - 1)], direction: .reverse, animated: true, completion: nil)

        // Do any additional setup after loading the view.
    }
    


    
    @objc func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        var index = pageContent.pageIndex
        
        if (index == NSNotFound)
        {
            return nil;
        }
        index+=1;
        
        if (index >= cities.count)
        {
            return nil;
        }
        return getViewControllerAtIndex(index: index)
    }
    
    @objc func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        var index = pageContent.pageIndex
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        index-=1;
        if (index == cities.count)
        {
            return nil;
        }
        return getViewControllerAtIndex(index: index)
    }
    
    
    func getViewControllerAtIndex(index: NSInteger) -> PageContentViewController
    {
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        pageContentViewController.pageIndex = index
        pageContentViewController.city = cities[index].name
        pageContentViewController.wheater = cities[index].weather[0].description.capitalized
        pageContentViewController.deg = "\(Int(cities[index].main.temp))º"
        print()
        print(cities[index].name)
        return pageContentViewController
    }

    func fetchData(city: String) {
        self.mainGroup.enter()
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=481fe76799a037e2752c45759ed5b3ab&units=metric")
        
        let session = URLSession.shared
        
        session.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { return }
            
            
            do {
              
                
                    let openWeather = try! JSONDecoder().decode(OpenWheather?.self, from: data)!
                print(openWeather.name)
                    self.cities.append(openWeather)
                    self.mainGroup.leave()
             
             
                
               
            } catch {
                print(error)
            }

            }.resume()
        
        return
    }
}
