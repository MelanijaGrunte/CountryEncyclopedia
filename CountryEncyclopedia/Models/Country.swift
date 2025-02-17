//
//  Country.swift
//  Countries
//
//  Created by Melanija Grunte on 13/02/2025.
//

import Foundation

struct Country: Equatable, Codable, Identifiable {
    public var id: String { name.official }

    let name: CountryName
    let cca2: String
    let cca3: String
    let currencies: [String: Currency]?
    let idd: CountryIDD
    let capital: [String]?
    let region: String
    let languages: [String: String]?
    let latlng: [Double]
    let area: Double
    let flag: String
    let population: Int
    let borders: [String]?
    let continents: [String]
    let translations: [String: CountryNameTranslation]?
    let capitalInfo: CapitalInfo

    var countryCode: String {
        (idd.root ?? "") + (idd.suffixes ?? []).joined()
    }

    var currenciesFormatted: String {
        guard let currencies, !currencies.isEmpty else { return "N/A" }
        return currencies.values
            .map { "\($0.name) (\($0.symbol))" }
            .joined(separator: ", ")
    }
}

struct CountryName: Equatable, Codable {
    let common: String
    let official: String
    let nativeName: [String: CountryNameTranslation]?
}

struct CountryNameTranslation: Equatable, Codable {
    let official: String
    let common: String
}

struct Currency: Equatable, Codable {
    let name: String
    let symbol: String
}

struct CapitalInfo: Equatable, Codable {
    let latlng: [Double]?
}

struct CountryIDD: Equatable, Codable {
    let root: String?
    let suffixes: [String]?
}

extension Country: Hashable {
    static func == (lhs: Country, rhs: Country) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
