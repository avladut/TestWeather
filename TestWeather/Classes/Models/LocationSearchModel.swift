//
//  LocationSearchModel.swift
//  TestWeather
//
//  Created by Alex on 28/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
struct LocationSearchModel {
    let description: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case structuredFormatting = "structured_formatting"
        case description
    }
    
    // The keys inside of the "user" object
    enum Subkeys: String, CodingKey {
        case mainText = "main_text"
    }
}

extension LocationSearchModel: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try container.decode(String.self, forKey: .description)
        let nameContainer = try container.nestedContainer(keyedBy: Subkeys.self, forKey: .structuredFormatting)
        name = try nameContainer.decode(String.self, forKey: .mainText)    }
}
