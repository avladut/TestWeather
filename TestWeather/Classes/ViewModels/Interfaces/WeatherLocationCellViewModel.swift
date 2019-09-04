//
//  WeatherLocationCellViewModel.swift
//  TestWeather
//
//  Created by Alex on 04/09/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
protocol WeatherLocationCellViewModel {
    
    typealias CompletionHandler = () -> Void
    
    static func getInstance (location: Location) -> WeatherLocationCellViewModel
    
    var locationName: String { get }
    var weatherDescription: String { get }
    
    func updateWeatherData(completion: @escaping CompletionHandler)
    func cancelWeatherDataUpdate()
}
