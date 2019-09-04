//
//  WeatherLocationListViewModelImpl.swift
//  TestWeather
//
//  Created by Alex on 04/09/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

class WeatherLocationListViewModelImpl {
    
    let dbInteractor: CoreDataInteractor
    
    private let disposeBag = DisposeBag()
    
    let shouldUpdate = BehaviorRelay(value: false)
    
    init (managedContext: NSManagedObjectContext) {
        self.dbInteractor = CoreDataInteractorImpl.getInstanceWithManagedContext(managedContext)
        
    }
    
    func getSavedLocations(_ bool: Bool) -> Observable<[WeatherLocationCellViewModel]> {
        let locations = BehaviorRelay<[WeatherLocationCellViewModel]>(value: [])
        
        dbInteractor.retrieveLocations().subscribe(onNext: { (locationsList) in
            
            guard locationsList.count > 0 else {
                locations.accept([])
                return
            }
            
            locations.accept(locationsList.compactMap({ (locationManagedObject) -> WeatherLocationCellViewModel? in
                return WeatherLocationCellViewModelImpl.getInstance(location: locationManagedObject)
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

extension WeatherLocationListViewModelImpl: WeatherLocationListViewModel {
   
    var savedLocations: Driver<[WeatherLocationCellViewModel]> {
        return self.shouldUpdate.asObservable()
            .throttle(.milliseconds(1500), scheduler: MainScheduler.instance)
            .flatMapLatest(self.getSavedLocations)
            .asDriver(onErrorJustReturn: [])
    }
    
    func updateSavedLocations() {
        self.shouldUpdate.accept(true)
    }
    
    static func getInstanceWithManagedContext(_ context: NSManagedObjectContext) -> WeatherLocationListViewModel {
        return WeatherLocationListViewModelImpl(managedContext: context)
    }
}
