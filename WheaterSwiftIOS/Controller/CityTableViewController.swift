//
//  CityTableViewController.swift
//  WheaterSwiftIOS
//
//  Created by WSR on 21/06/2019.
//  Copyright © 2019 WSR. All rights reserved.
//

import UIKit

class CityTableViewController: UIViewController, UITextFieldDelegate {

    let mainGroup = DispatchGroup()
    var cities: [OpenWheather] = []
    var saveCities: [String] = []
    var selectedIndex = 0
    var timer: Timer!

    
    
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            self.searchTextField.tintColor = .lightGray
            self.searchTextField.setIncon(UIImage(systemName: "magnifyingglass")!)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTextField.delegate = self

        
        for city in cities.reversed() {
            saveCities.append(city.name!)
        }
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let space = UIView()
        space.backgroundColor = .black
        tableView.tableFooterView = space

        mainGroup.wait()
        
//        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    @objc func updateData() {
       
       cities = []
        saveCities.reverse()
        for city in saveCities {
    
            fetchData(city: city)
            self.mainGroup.wait()
    
        }
        
        cities.reverse()
        
        tableView.reloadData()
//        
//        cities.reverse()
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
   

    func fetchData(city: String) {
        
        
        
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=481fe76799a037e2752c45759ed5b3ab&units=metric")
        self.mainGroup.enter()
        if url == nil {
            saveCities.removeAll { $0 == city}
            showAlert(message: "City not found")
            return
        }
        
        let session = URLSession.shared
        
        session.dataTask(with: url!) { (data, response, err) in
            guard let data = data else { return }

            
            do {
                let openWeather = try? JSONDecoder().decode(OpenWheather?.self, from: data)!
                let openWeatherError = try? JSONDecoder().decode(OpenWeatherError?.self, from: data)!
                
                if openWeatherError?.code == 404 {
                   self.mainGroup.leave()
                    
                        self.showAlert(message: "City not found")

                        
                        return
                    
                    
                } else {
                    if openWeather != nil {
                        self.cities.append(openWeather!)
                        self.mainGroup.leave()
                    } else {
                        self.mainGroup.leave()
                    }
                   
                }

              
           
            } catch {
                print(error)
            }
            
            }.resume()
        
        return
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        edititengEnd()
        AddCity(self)
        return true
    }
    
    func edititengEnd() {
        self.view.endEditing(true)
        
//        tableViewTopConstraint.constant = 0
//        UIView.animate(withDuration: 0.2) {
//            self.view.layoutIfNeeded()
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        edititengEnd()
    }
    
    @IBAction func printStart(_ sender: Any) {
//        tableViewTopConstraint.constant = -250
//        UIView.animate(withDuration: 0.2) {
//            self.view.layoutIfNeeded()
//        }
        
    }

    
    @IBAction func AddCity(_ sender: Any) {
        guard let cityName = searchTextField.text else { return }
        
        if cities.contains(where: { (OpenWheather: OpenWheather) -> Bool in
            if OpenWheather.name == cityName.capitalized {
                showAlert(message: "City already exist")
               
                return true
            } else {
                return false
            }
        }) {
           return
        }
        
        saveCities.reverse()
            saveCities.append(cityName)
        searchTextField.text = ""
        edititengEnd()
        updateData()
    }
    
}

extension CityTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CityTableViewCell
        let uiImage = UIImageView(image: UIImage(named: "CustomTableCell"))
//        uiImage.image =
        tableViewHeightConstraint.constant = CGFloat(cities.count * 81)
        let city = cities[indexPath.row]

        let timezone: TimeZone = TimeZone(secondsFromGMT: city.timezone!)!
        let currentDate = Date()
        let formater = DateFormatter()
        
        formater.dateFormat = "h:mm a"
        formater.timeZone = timezone
        
        cell.backgroundView = uiImage
        cell.cityLabel.text = city.name
        cell.degLabel.text = "\(Int((city.main?.temp!)!))º"
        cell.timeLabel.text = formater.string(from: currentDate)
       
        // Configure the cell...
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = cities.count - 1 - indexPath.row
//        timer.invalidate()
        performSegue(withIdentifier: "SelectCity", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            cities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}


extension UITextField {
    
    func setIncon(_ image: UIImage) {
        
        let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        
        let iconContainerView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        
        leftView = iconContainerView
        leftViewMode = .always
    }
}
