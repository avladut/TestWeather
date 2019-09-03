//
//  CoreDataInteractorImpl.swift
//  TestWeather
//
//  Created by Alex on 30/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

class CoreDataInteractorImpl {
    
    static let locationEntityName = "Location"
    
    let context: NSManagedObjectContext
    
    init(managedContext: NSManagedObjectContext) {
        self.context = managedContext
    }
}

extension CoreDataInteractorImpl: CoreDataInteractor {
    
    static func getInstanceWithManagedContext(_ context: NSManagedObjectContext) -> CoreDataInteractor {
        return CoreDataInteractorImpl(managedContext: context)
    }
    
    func saveLocation(location: LocationSearchModel) throws {
        
        guard let locationManagedObject = NSEntityDescription.insertNewObject(forEntityName: type(of: self).locationEntityName, into: context) as? Location else {
            throw DBErrors.entityCreationError
        }
        locationManagedObject.name = location.name
        do {
            try context.save()
            
        } catch let error {
            throw error
        }
    }
    
    
    func retrieveLocations() -> Observable<[Location]> {
        return Observable.create {[weak self] (observer) -> Disposable in
            
            guard let selfUnwrp = self else {
                return Disposables.create()
            }
            
            
            let locationsFetchRequest = NSFetchRequest<Location>(entityName: type(of: selfUnwrp).locationEntityName)
            let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: locationsFetchRequest) { (asynchronousFetchResult) in
                
                // Retrieves an array of dogs from the fetch result `finalResult`
                guard let locations = asynchronousFetchResult.finalResult else {
                    return
                }
                
                observer.onNext(locations)
            }
            
            do {
                try selfUnwrp.context.execute(asynchronousFetchRequest)
            } catch let error {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    
}
