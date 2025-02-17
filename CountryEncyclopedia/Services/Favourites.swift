//
//  Favourites.swift
//  Countries
//
//  Created by Melanija Grunte on 17/02/2025.
//

import Foundation

@Observable
class Favourites {
    private let userDefaults = UserDefaults.standard
    private(set) var favouriteIds: Set<String>
    private let key = "favourites"

    init() {
        favouriteIds = []
        load()
    }

    func contains(_ country: Country) -> Bool {
        favouriteIds.contains(country.cca3)
    }

    func toggle(_ country: Country) {
        if contains(country) {
            remove(country)
        } else {
            add(country)
        }
    }

    func add(_ country: Country) {
        favouriteIds.insert(country.cca3)
        save()
    }

    func remove(_ country: Country) {
        favouriteIds.remove(country.cca3)
        save()
    }

    func save() {
        userDefaults.set(Array(favouriteIds), forKey: key)
    }

    func load() {
        let favouritesArray = userDefaults.stringArray(forKey: key) ?? []
        favouriteIds = Set(favouritesArray)
    }

    func allFavouritedCountries(from fullCountryList: [Country]) -> [Country] {
        fullCountryList.filter { favouriteIds.contains($0.cca3) }
    }
}
