//
//  SearchLocationsViewModelImplTests.swift
//  TestWeatherTests
//
//  Created by Alex on 05/09/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import XCTest
import RxBlocking
import RxTest
import RxSwift
import RxCocoa
@testable import TestWeather

//honestly no ideea how to test rxswift code, and too little time to learn now :)
class SearchLocationsViewModelImplTests: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var searchLocationInteractorMock: SearchLocationInteractor!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
