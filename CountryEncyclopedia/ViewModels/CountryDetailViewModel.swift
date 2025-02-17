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

    func getPopulationRank() -> Int {
        var countryPopulations = fullCountryList.map { $0.population }
        countryPopulations.sort(by: >)
        let index = countryPopulations.firstIndex(where: { $0 < country.population })
        return index ?? 0
    }

    var flagUrl: URL {
        Client.flagEndpoint(for: country.cca2)
    }
}
