//
//  LocationWeatherCell.swift
//  TestWeather
//
//  Created by Alex on 29/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

class LocationWeatherCell: UITableViewCell {
    
    @IBOutlet weak var lblPlaceName: UILabel!
    public static let reuseIdentifier = "LocationWeatherCellReuseId"
    @IBOutlet weak var lblWeatherDescription: UILabel!
    
    var locationViewModel: WeatherLocationCellViewModel?
    
    public func config (_ location: WeatherLocationCellViewModel) {
        self.locationViewModel = location
        self.lblPlaceName.text = location.locationName
        location.updateWeatherData {
            DispatchQueue.main.async {[weak self] in
                self?.lblWeatherDescription.text = location.weatherDescription
            }
        }
    }
    
    public func clearCell() {
        self.lblPlaceName.text = ""
        self.lblWeatherDescription.text = ""
        //self.locationViewModel?.cancelWeatherDataUpdate()
        self.locationViewModel = nil
    }
}
