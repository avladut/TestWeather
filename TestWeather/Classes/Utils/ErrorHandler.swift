//
//  ErrorHandler.swift
//  TestWeather
//
//  Created by Alex on 02/09/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import UIKit

enum GeneralError: Error {
    case indexOutOfBounds
}

enum DBErrors: Error {
    case entityCreationError
}

class ErrorHandler {
    
    enum MissingDataMessages: String {
        case missingInfoForLabel = "Unknown text"
        case missingPairKey = "Unknown pair key"
    }
    
    public static func showSimpleErrorAlertOnController (_ parentController: UIViewController?, error: Error) {
        
        guard let parentController = parentController else {
            return
        }
        
        //can be improved
        let message = error.localizedDescription
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        
        parentController.present(alertController, animated: true, completion: nil)
    }
}
