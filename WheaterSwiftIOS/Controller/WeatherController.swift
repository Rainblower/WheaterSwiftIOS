//
//  WeatherController.swift
//  WheaterSwiftIOS
//
//  Created by WSR on 20/06/2019.
//  Copyright © 2019 WSR. All rights reserved.
//

import UIKit

class WeatherController: UIPageViewController  {
    
    weak var weatherDelegate: WeatherPageViewControllerDelegate?
    
    let group = DispatchGroup()
    let mainGroup = DispatchGroup()
    var cities: [OpenWheather] = []
    let saveCities = ["Moscow","Kazan","Omsk","Sankt-peterburg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        
        
        
        for city in saveCities.reversed() {
            
            fetchData(city: city)
            self.mainGroup.wait()
            
        }
        mainGroup.wait()
        
        
        setViewControllers([getViewControllerAtIndex(index: cities.reversed().count-1)],
                           direction: .forward,
                           animated: true)
        
        
        weatherDelegate?.weatherPageViewController(weatherPageViewController: self,
                                                   didUpdatePageCount: cities.count)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let desitnationViewController = segue.destination as? CityTableViewController else { return }
        desitnationViewController.cities = cities
    }
    
    @IBAction func unwindToTable(_ unwindSegue: UIStoryboardSegue) {
        guard let sourceViewController = unwindSegue.source as? CityTableViewController else { return }
        let cityIndex = sourceViewController.selectedIndex
        
        cities = sourceViewController.cities
        weatherDelegate?.weatherPageViewController(weatherPageViewController: self, didUpdatePageCount: cities.count)
        
        weatherDelegate?.weatherPageViewController(weatherPageViewController: self, didUpdatePageIndex: cityIndex)
        setViewControllers([getViewControllerAtIndex(index: cityIndex)],
                           direction: .forward,
                           animated: true)
        
        // Use data from the view controller which initiated the unwind segue
    }
    
    
    
    //        self.setViewControllers([getViewControllerAtIndex(index: cities.count - 1)], direction: .reverse, animated: true, completion: nil)
    
    // Do any additional setup after loading the view.
    
    
    
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

extension WeatherController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        
        if let firstViewController = viewControllers?.first,
            let firstIndex = cities.firstIndex(where: { (ow) -> Bool in
                guard let firstController = firstViewController as? PageContentViewController else { return false }
                if ow.name == firstController.city {
                    return true
                } else {
                    return false
                }}){
            weatherDelegate?.weatherPageViewController(weatherPageViewController: self,
                                                       didUpdatePageIndex: firstIndex)
        }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
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
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
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
        pageContentViewController.city = cities[index].name!
        pageContentViewController.wheater = cities[index].weather![0].description!.capitalized
        pageContentViewController.deg = "\(Int(cities[index].main!.temp!))º"
        print()
        print(cities[index].name)
        return pageContentViewController
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return cities.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstController = viewControllers?.first,
            let firstIndex = cities.firstIndex(where: { (ow) -> Bool in
                guard let firstController = firstController as? PageContentViewController else { return false }
                if ow.name == firstController.city {
                    return true
                } else {
                    return false
                }}) else { return 0}
        
        return firstIndex
    }
    
}


protocol WeatherPageViewControllerDelegate: class {
    
    
    //     Called when the number of pages is updated.
    
    
    func weatherPageViewController(weatherPageViewController: WeatherController,
                                   didUpdatePageCount count: Int)
    
    
    //     Called when the current index is updated.
    
    
    func weatherPageViewController(weatherPageViewController: WeatherController,
                                   didUpdatePageIndex index: Int)
    
}
