//
//  CoreDataInteractor.swift
//  TestWeather
//
//  Created by Alex on 30/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

protocol CoreDataInteractor {
    func saveLocation (location: LocationSearchModel) throws
    func retrieveLocations () -> Observable<[Location]>
    
    static func getInstanceWithManagedContext(_ context: NSManagedObjectContext) -> CoreDataInteractor
}
