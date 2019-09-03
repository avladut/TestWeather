//
//  SearchLocationCellViewModelImpl.swift
//  TestWeather
//
//  Created by Alex on 29/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
class SearchLocationCellViewModelImpl {
    let searchLocation: LocationSearchModel
    
    init (_ searchLocationModel: LocationSearchModel) {
        self.searchLocation = searchLocationModel
    }
}

extension SearchLocationCellViewModelImpl: SearchLocationCellViewModel {
    var text: String {
        return self.searchLocation.description
    }

}
