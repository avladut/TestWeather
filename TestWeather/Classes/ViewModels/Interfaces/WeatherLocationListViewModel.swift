//
//  WeatherLocationListViewModel.swift
//  TestWeather
//
//  Created by Alex on 04/09/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

protocol WeatherLocationListViewModel {
    
    static func getInstanceWithManagedContext (_ context: NSManagedObjectContext) -> WeatherLocationListViewModel
    
    var savedLocations: Driver<[WeatherLocationCellViewModel]> { get }
    
    func updateSavedLocations ()
}
