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
    
    
    func getGyag(){
        let completeURL = "\(baseURL)"
        print(completeURL)
        getGyagRequest(url: completeURL )
    }
    
    func getGyagRequest(url: String) {
        
        if let url = URL(string: url) {

            APIService.shared.getRequest(url: url, type: GyagData.self, completionHandler: { (response) in
                      
                let gyag = GyagModel(joke: response.joke, id: response.id, status: response.status)
                self.delegate?.updateGyag(gyagModel: gyag)
                
                   }) { (error) in
                       print("Could not fetch images!")
                   }
        }
        
    }
    
}
