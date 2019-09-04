//
//  WeatherLocationCellViewModelImpl.swift
//  TestWeather
//
//  Created by Alex on 04/09/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import Alamofire

class WeatherLocationCellViewModelImpl {
    
    private static let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private static let cityKeyParam = "q"
    private static let apiKeyParam = "APPID"
    
    
    let location: Location
    var weatherData: WeatherDataModel?
    var apiRequest: DataRequest?
    
    //Should be in a separate interactor
    //too tired to write it, it's 3 AM
    static let weatherAPIKey = ""
    
    init(location: Location) {
        self.location = location
    }
}

extension WeatherLocationCellViewModelImpl: WeatherLocationCellViewModel {
    func cancelWeatherDataUpdate() {
        self.apiRequest?.cancel()
    }
    
    var locationName: String {
        return self.location.name ?? "Unknown"
    }
    
    var weatherDescription: String {
        return self.weatherData?.description ?? "updating..."
    }
    
    static func getInstance(location: Location) -> WeatherLocationCellViewModel {
        return WeatherLocationCellViewModelImpl (location: location)
    }
    
    func updateWeatherData(completion: @escaping CompletionHandler) {
        let selfType = type(of: self)
        self.apiRequest = Alamofire.request(selfType.baseURL,
                          method: .get,
                          parameters: [
                            selfType.cityKeyParam: self.locationName,
                            selfType.apiKeyParam: WebApiKeys.weatherApiKey
            ]).validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    
                    guard let responseDict = response.result.value as? [String: Any],
                        let responseArray = responseDict["weather"] as? [[String: Any]], responseArray.count > 0 else {
                            let error = NSError(domain: "response cannot be read", code: -1, userInfo: nil)
                            print (error.localizedDescription)
                            return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let jsonData = try JSONSerialization.data(withJSONObject: responseArray[0], options: .prettyPrinted)
                        self.weatherData = try decoder.decode(WeatherDataModel.self, from: jsonData)
                        completion()
                        
                    } catch let error {
                        print("Failed to deserialise json: \(error.localizedDescription)")
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    
}
