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
    let disposeBag = DisposeBag()
    
    private var searchLocations: [LocationSearchModel] = []
    
    let searchText = BehaviorRelay(value: "")
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
                    .throttle(0.3, scheduler: MainScheduler.instance)
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
    
    
    func searchLocation(pattern: String) -> ObservableLocations {
        
        let cells = BehaviorRelay<[SearchLocationCellViewModel]>(value: [])
        
        searchPlacesAPI.searchLocationsStartingWith(pattern).subscribe(onNext: {[weak self] (locationsList) in
            self?.searchLocations = locationsList
            guard locationsList.count > 0 else {
                cells.accept([])
                return
            }
            
            cells.accept(locationsList.compactMap({ (locationSearchModel) -> SearchLocationCellViewModel? in
                return SearchLocationCellViewModelImpl(locationSearchModel)
            }))
            
        }, onError: { (err) in
            print("in observable error \(err.localizedDescription)")
        }, onCompleted: {
            print("in observable completed ")
        }, onDisposed: {
            print("in observable disposed")
        }).disposed(by: disposeBag)
        
       
        return cells.asObservable()
        
    }
}
