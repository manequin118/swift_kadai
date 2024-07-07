//
//  WeatherDataManager.swift
//  Clima
//
//  Created by Daegeon Choi on 2020/04/15.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

//MARK: Delegate protocol
protocol WeatherManagerDelegate {
    func updateWeather(weatherModel: WeatherModel)
    func failedWithError(error: Error)
}

//MARK: DataManager struct
struct WeatherDataManager{
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=4e415e4ab2aaed09e04d8419beedee19&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    //MARK:- fetchWeather
    func fetchWeather(_ city: String){
        let completeURL = "\(baseURL)&q=\(city)"
        print(completeURL)
        getWeatherRequest(url: completeURL )
    }
    
    func fetchWeather(_ latitude: Double, _ longitude: Double){

        let completeURL = "\(baseURL)&lat=\(latitude)&lon=\(longitude)"
        print(completeURL)
        getWeatherRequest(url: completeURL )
    }
    
    func getWeatherRequest(url: String) {
        
        if let url = URL(string: url) {

            APIService.shared.getRequest(url: url, type: WeatherData.self, completionHandler: { (response) in
                      
                let weather = WeatherModel(cityName: response.name, conditionId: response.weather[0].id, temperature: response.main.temp)
                self.delegate?.updateWeather(weatherModel: weather)
                
                   }) { (error) in
                       print("Could not fetch images!")
                   }
        }
    }

    
}

