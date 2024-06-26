//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var backgroud: UIImageView!
    @IBOutlet weak var gyagLabel: UILabel!
    
    //MARK: Properties
    var weatherManager = WeatherDataManager()
    var gyagManager = GyagDataManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        weatherManager.delegate = self
        gyagManager.delegate = self
        searchField.delegate = self
    }
    
    @IBAction func cityListButton(_ sender: Any) {
           let cityVC = CityListViewController()
           self.navigationController?.pushViewController(cityVC, animated: true)
    }
    
    @IBAction func gyagBtnClicked(_ sender: UIButton) {
        
        fetchGyag()
        
    }

    func fetchGyag() {
       
            gyagManager.getGyag()
    }


}
 
//MARK:- TextField extension
extension WeatherViewController: UITextFieldDelegate{
    
        @IBAction func searchBtnClicked(_ sender: UIButton) {
            searchField.endEditing(true)    //dismiss keyboard
            print(searchField.text!)
            
            searchWeather()
            
        }
    
        func searchWeather(){
            if let cityName = searchField.text{
                weatherManager.fetchWeather(cityName)
            }
            chageBackgroundImage(searchField.text!)
            
            print("action:search, city:"+searchField.text!)
        }
    
        func chageBackgroundImage(_ city: String){
            
            if city == "Tokyo" {
                backgroud.image = UIImage(named: "AppIcon")
            }else {
                backgroud.image = UIImage(named: "background")
            }
        }
        
        // when keyboard return clicked
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            searchField.endEditing(true)    //dismiss keyboard
            print(searchField.text!)
            
            searchWeather()
            return true
        }
        
        // when textfield deselected
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            // by using "textField" (not "searchField") this applied to any textField in this Controller(cuz of delegate = self)
            if textField.text != "" {
                return true
            }else{
                textField.placeholder = "Type something here"
                return false            // check if city name is valid
            }
        }
        
        // when textfield stop editing (keyboard dismissed)
        func textFieldDidEndEditing(_ textField: UITextField) {
    //        searchField.text = ""   // clear textField
        }
}

//MARK:- View update extension
extension WeatherViewController: WeatherManagerDelegate, GyagManagerDelegate{
    
    func updateWeather(weatherModel: WeatherModel){
        DispatchQueue.main.sync {
            temperatureLabel.text = weatherModel.temperatureString
            cityLabel.text = weatherModel.cityName
            self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
        }
    }
    
    func updateGyag(gyagModel: GyagModel){
        DispatchQueue.main.sync {
            gyagLabel.text = gyagModel.joke
        }
    }
    
    
    func failedWithError(error: Error){
        print(error)
    }
}

// MARK:- CLLocation
extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationButtonClicked(_ sender: UIButton) {
        // Get permission
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat, lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
