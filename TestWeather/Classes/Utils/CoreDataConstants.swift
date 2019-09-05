//
//  CoreDataConstants.swift
//  TestWeather
//
//  Created by Alex on 04/09/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct CoreDataConstants {
    static let mainContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    struct EntityNames {
        static let locationEntityName = "Location"
    }
}

