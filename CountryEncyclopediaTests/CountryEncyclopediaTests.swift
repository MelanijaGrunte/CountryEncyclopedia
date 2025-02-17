//
//  CountryEncyclopediaTests.swift
//  CountryEncyclopediaTests
//
//  Created by Melanija Grunte on 17/02/2025.
//

import Combine
@testable import CountryEncyclopedia
import XCTest

final class CountryEncyclopediaTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    func testCountriesJson() async {
        let countryListViewModel = CountryListViewModel(
            countryListProvider: .test(for: Bundle(for: type(of: self)))
        )

        let loadedEx = expectation(description: "viewState publishes loaded value")

        countryListViewModel.$viewState
            .sink { actualViewState in
                if case let .loaded(countries) = actualViewState {
                    loadedEx.fulfill()
                    XCTAssertEqual(countries.count, 5)
                    self.testCountriesBorders(from: countries)
                }
            }
            .store(in: &cancellables)

        await countryListViewModel.loadList()

        await fulfillment(of: [loadedEx], timeout: 10)
    }

    private func testCountriesBorders(from fullCountryList: [Country]) {
        let latvia = fullCountryList.first(where: { $0.name.official == "Republic of Latvia" })

        let latviasNeighboringCountries = latvia?.neighboringCountries(countriesList: fullCountryList)

        XCTAssertEqual(latviasNeighboringCountries?.count, 4)
    }

    func testSearch() async {
        let countryListViewModel = CountryListViewModel(
            countryListProvider: .test(for: Bundle(for: type(of: self)))
        )

        let searchEx = expectation(description: "viewState publishes search value")

        countryListViewModel.$viewState
            .sink { actualViewState in
                if case let .search(countries) = actualViewState {
                    searchEx.fulfill()
                    XCTAssertEqual(countries.count, 1)
                }
            }
            .store(in: &cancellables)

        await countryListViewModel.loadList()
        countryListViewModel.searchText = "lettland"

        await fulfillment(of: [searchEx], timeout: 10)
    }
}

extension CountryListProvider {
    static func test(for bundle: Bundle) -> CountryListProvider { CountryListProvider(getCountries: {
        guard let path = bundle.path(forResource: "CountryListLocal", ofType: "json") else {
            return .failure(NSError(domain: "File not found", code: 1))
        }

        guard let data = FileManager.default.contents(atPath: path) else {
            return .failure(NSError(domain: "Data not found", code: 1))
        }

        let decoder = JSONDecoder()

        do {
            let countries = try decoder.decode([Country].self, from: data)
            return .success(countries)
        } catch {
            return .failure(error)
        }
    }) }
}
