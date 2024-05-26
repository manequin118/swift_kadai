//
//  GyagDataManager.swift
//  Clima
//
//  Created by 中佐徹也 on 2024/05/25.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
protocol GyagManagerDelegate {
    func updateGyag(gyagModel: GyagModel)
    func failedWithError(error: Error)
}

struct GyagDataManager{
    let baseURL = "https://icanhazdadjoke.com/"
    
    var delegate: GyagManagerDelegate?
    
    //MARK:- fetchWeather
    func fetchGyag(_ city: String){
        let completeURL = "\(baseURL)"
        print(completeURL)
        performRequest(url: completeURL )
    }
    
//    func fetchWeather(_ latitude: Double, _ longitude: Double){
//
//        let completeURL = "\(baseURL)&lat=\(latitude)&lon=\(longitude)"
//        print(completeURL)
//        performRequest(url: completeURL )
//    }
    
    //MARK: URL methods
    func performRequest(url: String){
        // 1. Create URL
        if let url = URL(string: url){          // URL initializer create optional URL
            
            // 2. Create URL Session
            let session = URLSession(configuration: .default)
            
            // 3. Give the session with tasks
            let task = session.dataTask(with: url) { (data, response, error) in
                // if error exists
                if error != nil{
                    self.delegate?.failedWithError(error: error!)
                    return
                }
                
                // Decode JSON
                if let safeData = data{
                    // "self" is necessery in closure
                    if let gyag = self.parseJSON(gyagData: safeData) {
                        self.delegate?.updateGyag(gyagModel: gyag)
                    }
                }
            }

            // what task do: go to url -> grab data -> come back
            
            // 4. Start the task
            task.resume()
        }
    }   // [END] of performRequest()
    
    // decode JSON
    func parseJSON(gyagData: Data) -> GyagModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(GyagData.self, from: gyagData)
            print("decoded: \(decodedData)")
            
            return GyagModel(joke: decodedData.joke, id: decodedData.id, status: decodedData.status)
            
        }catch {
            delegate?.failedWithError(error: error)
            return nil
        }
    }
    
}
