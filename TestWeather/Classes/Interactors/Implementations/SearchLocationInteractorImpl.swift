//
//  SearchLocationInteractorImpl.swift
//  TestWeather
//
//  Created by Alex on 28/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class SearchLocationInteractorImpl {
    
    let baseURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    struct ParamNames {
        static let apiKey = "key"
        static let searchKey = "input"
        static let typeKey = "type"
    }
    
    struct ParamValues {
        
        static let googleAPIKey = "AIzaSyDD6r3v9MxaCTEv1y5KhpLQE_zJIW_kGBc"
        static let type = "(cities)"
    }
    
}

extension SearchLocationInteractorImpl: SearchLocationInteractor {
    
    func searchLocationsStartingWith(_ pattern: String) -> ObservableResponseData
    {
        return Observable.create({[weak self] (observer) -> Disposable in
            
            guard let selfUnwr = self else {
                return Disposables.create()
            }
            
            Alamofire.request(selfUnwr.baseURL,
                              method: .get,
                              parameters: [
                                ParamNames.searchKey: pattern,
                                ParamNames.typeKey: ParamValues.type,
                                ParamNames.apiKey: ParamValues.googleAPIKey
                ]).validate()
                .responseJSON { response in
                    
                    switch response.result {
                    case .success:
                        
                        guard let responseDict = response.result.value as? [String: Any],
                            let responseArray = responseDict["predictions"] as? [[String: Any]] else {
                                let error = NSError(domain: "response cannot be read", code: -1, userInfo: nil)
                                observer.onError(error)
                                return
                        }
                        
                        do {
                            let decoder = JSONDecoder()
                            let jsonData = try JSONSerialization.data(withJSONObject: responseArray, options: .prettyPrinted)
                            let locationsList = try decoder.decode([LocationSearchModel].self, from: jsonData)
                            observer.onNext(locationsList)
                            observer.onCompleted()
                        } catch let error {
                            print("Failed to deserialise json: \(error.localizedDescription)")
                            observer.onError(error)
                        }
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        })
        
        
    }
    
    static func getInstance() -> SearchLocationInteractor {
        return SearchLocationInteractorImpl()
    }
    
    
    
}
