//
//  Country.swift
//  DemoApp
//
//  Created by Mohammad Yasir Perwez on 27.12.23.
//

import Foundation

struct Country: Decodable, Equatable, Hashable {

    let name: String
    let population: Int
    let capital: [String]?
    let flagURL: String

    enum CodingKeys: String, CodingKey {
        case name
        case population
        case capital
        case flagURL
        case flags

        enum NameCodingKeys: String, CodingKey {
            case official
        }

        enum FlagCodingKeys: String, CodingKey {
            case png
        }

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let nameObject = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        self.name = try nameObject.decode(String.self, forKey: CodingKeys.NameCodingKeys.official)
        self.population = try container.decode(Int.self, forKey: .population)
        self.capital = try container.decodeIfPresent([String].self, forKey: .capital)
        let flagURLContainer = try container.nestedContainer(keyedBy: CodingKeys.FlagCodingKeys.self, forKey: .flags)
        self.flagURL = try flagURLContainer.decode(String.self, forKey: CodingKeys.FlagCodingKeys.png)
    }

    init(name: String, population: Int, capital: [String]?, flagURL: String) {
        self.name = name
        self.population = population
        self.capital = capital
        self.flagURL = flagURL
    }
}
