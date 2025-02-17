//
//  CountryDetailViewModel.swift
//  Countries
//
//  Created by Melanija Grunte on 13/02/2025.
//

import Foundation

class CountryDetailViewModel: ObservableObject {
    let country: Country
    let fullCountryList: [Country]

    init(
        country: Country,
        fullCountryList: [Country]
    ) {
        self.country = country
        self.fullCountryList = fullCountryList
    }

    var populationRank: Int? {
        let countriesSortedByPopulation = fullCountryList.sorted(by: { $0.population > $1.population })
        if let indexOfCountryInSortedArray = countriesSortedByPopulation.firstIndex(of: country) {
            return indexOfCountryInSortedArray + 1
        } else {
            return nil
        }
    }
    
    var populationRankFormatted: String {
        populationRank.map(\.description) ?? "N/A"
    }

    var flagUrl: URL {
        Client.flagEndpoint(for: country.cca2)
    }
}
