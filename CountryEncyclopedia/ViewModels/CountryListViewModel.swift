//
//  CountryListViewModel.swift
//  Countries
//
//  Created by Melanija Grunte on 13/02/2025.
//

import Foundation

class CountryListViewModel: ObservableObject {
    private let countryListProvider: CountryListProvider

    @Published var viewState: CountriesListViewState = .loading
    @Published var favourites = Favourites()
    @Published var searchText: String = "" {
        didSet {
            filterCountries()
        }
    }

    var fullCountryList: [Country] = []

    init(countryListProvider: CountryListProvider) {
        self.countryListProvider = countryListProvider
    }

    func loadList() async {
        let countriesResult = await countryListProvider.getCountries()
        switch countriesResult {
        case let .success(countries):
            fullCountryList = countries
            updateState(newValue: .loaded(countries))
        case let .failure(error):
            print("Error fetching countries: \(error)")
            updateState(newValue: .failure(error))
        }
    }

    func updateState(newValue: CountriesListViewState) {
        DispatchQueue.main.async { [weak self] in
            self?.viewState = newValue
        }
    }

    func loadFavourites() {
        let favouritesList = favourites.allFavouritedCountries(from: fullCountryList)
        updateState(newValue: .favorites(favouritesList))
    }

    func closeFavourites() {
        updateState(newValue: .loaded(fullCountryList))
    }

    func filterCountries() {
        guard !searchText.isEmpty else {
            updateState(newValue: .loaded(fullCountryList))
            return
        }

        let lowercasedSearchText = searchText.lowercased()

        let filteredCountries = fullCountryList.filter {
            $0.name.official.lowercased().contains(lowercasedSearchText) ||
                $0.name.common.lowercased().contains(lowercasedSearchText) ||
                $0.translations?.values.map(\.common).contains(where: { $0.lowercased().contains(lowercasedSearchText) }) ?? false ||
                $0.translations?.values.map(\.official).contains(where: { $0.lowercased().contains(lowercasedSearchText) }) ?? false
        }

        updateState(newValue: .search(filteredCountries))
    }
}
