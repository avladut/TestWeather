//
//  SearchLocationsViewModel.swift
//  TestWeather
//
//  Created by Alex on 29/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchLocationsViewModel {
    typealias ObservableLocations = Observable<[SearchLocationCellViewModel]>
    
    var searchLocationsResult: Driver<[SearchLocationCellViewModel]> { get }
    var searchString: BehaviorRelay<String> { get }
    
    func searchLocation(pattern: String) -> ObservableLocations
    func selectLocationAtIndex(index: Int) throws
}
