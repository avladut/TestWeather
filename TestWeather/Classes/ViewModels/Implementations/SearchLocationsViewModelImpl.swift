//
//  SearchLocationsViewModelImpl.swift
//  TestWeather
//
//  Created by Alex on 29/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchLocationsViewModelImpl {
    
    let searchPlacesAPI = SearchLocationInteractorImpl.getInstance()
    let coreDataInteractor = CoreDataInteractorImpl.getInstanceWithManagedContext((UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    private let disposeBag = DisposeBag()
    
    private var searchLocations: [LocationSearchModel] = []
    
    let searchText = BehaviorRelay(value: "")
    
    func searchLocation(pattern: String) -> ObservableLocations {
        
        let locations = BehaviorRelay<[SearchLocationCellViewModel]>(value: [])
        
        searchPlacesAPI.searchLocationsStartingWith(pattern).subscribe(onNext: {[weak self] (locationsList) in
            self?.searchLocations = locationsList
            guard locationsList.count > 0 else {
                locations.accept([])
                return
            }
            
            locations.accept(locationsList.compactMap({ (locationSearchModel) -> SearchLocationCellViewModel? in
                return SearchLocationCellViewModelImpl(locationSearchModel)
            }))
            
            }, onError: { (err) in
                print("in observable error \(err.localizedDescription)")
        }, onCompleted: {
            print("in observable completed ")
        }, onDisposed: {
            print("in observable disposed")
        }).disposed(by: disposeBag)
        
        return locations.asObservable()
    }
}

extension SearchLocationsViewModelImpl: SearchLocationsViewModel {
    var searchString: BehaviorRelay<String> {
        get {
            return searchText
        }
    }
    
    var searchLocationsResult: Driver<[SearchLocationCellViewModel]> {
        get {
            return self.searchText.asObservable()
                .throttle(.milliseconds(1500), scheduler: MainScheduler.instance)
                .distinctUntilChanged()
                .flatMapLatest(self.searchLocation)
                .asDriver(onErrorJustReturn: [])
        }
    }
    
    func selectLocationAtIndex(index: Int) throws {
        guard index < searchLocations.count else {
            throw GeneralError.indexOutOfBounds
        }
        do {
            try coreDataInteractor.saveLocation(location: searchLocations[index])
        } catch let error {
            throw error
        }
        
    }
}
