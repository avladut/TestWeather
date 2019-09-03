//
//  SearchLocationInteractor.swift
//  TestWeather
//
//  Created by Alex on 28/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

protocol SearchLocationInteractor {
    typealias ObservableResponseData = Observable<[LocationSearchModel]>
    
    func searchLocationsStartingWith(_ pattern: String) -> ObservableResponseData
    
    static func getInstance () -> SearchLocationInteractor 
}
