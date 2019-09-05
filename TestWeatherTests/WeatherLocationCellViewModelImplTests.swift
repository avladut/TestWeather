//
//  WeatherLocationCellViewModelImplTests.swift
//  TestWeatherTests
//
//  Created by Alex on 05/09/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import XCTest
import CoreData
@testable import TestWeather

class WeatherLocationCellViewModelImplTests: XCTestCase {
    
    private var inMemoryObjectContext: NSManagedObjectContext!
    private var locationWeatherCellVM: WeatherLocationCellViewModel!
    private let placeTestName = "London"
    
    
    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        let managedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }

    override func setUp() {
        
        self.inMemoryObjectContext = setUpInMemoryManagedObjectContext()
        let locationManagedObject = NSEntityDescription.insertNewObject(forEntityName: CoreDataConstants.EntityNames.locationEntityName, into: inMemoryObjectContext) as! Location
        
        locationManagedObject.name = placeTestName
        self.locationWeatherCellVM = WeatherLocationCellViewModelImpl.getInstance(location: locationManagedObject)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialValues() {
        XCTAssertEqual(self.locationWeatherCellVM.locationName, self.placeTestName)
        XCTAssertEqual(self.locationWeatherCellVM.weatherDescription, WeatherLocationCellViewModelImpl.defaultWeatherDescription)
    }
    
    func testValuesAfterUpdate() {
        
        let ex = expectation(description: "Expecting to modify weather description")
        self.locationWeatherCellVM.updateWeatherData {
            
            XCTAssertEqual(self.locationWeatherCellVM.locationName, self.placeTestName)
            XCTAssertNotEqual(self.locationWeatherCellVM.weatherDescription, WeatherLocationCellViewModelImpl.defaultWeatherDescription)
            ex.fulfill()
        }
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
        
    }
    

}
