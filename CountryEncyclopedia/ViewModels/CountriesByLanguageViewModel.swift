//
//  CountriesByLanguageViewModel.swift
//  Countries
//
//  Created by Melanija Grunte on 13/02/2025.
//

import Foundation

class CountriesByLanguageViewModel: ObservableObject {
    let languageCode: String
    let languageName: String
    let fullCountryList: [Country]

    @Published var countries: [Country] = []

    init(languageCode: String, languageName: String, fullCountryList: [Country]) {
        self.languageCode = languageCode
        self.languageName = languageName
        self.fullCountryList = fullCountryList
    }

    func loadCountriesByLanguage() {
        countries = fullCountryList.filter { ($0.languages ?? [:]).keys.contains(languageCode) }
    }
}
