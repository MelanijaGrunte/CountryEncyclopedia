//
//  CountryListProvider.swift
//  Countries
//
//  Created by Melanija Grunte on 17/02/2025.
//

import Foundation

struct CountryListProvider {
    var getCountries: () async -> Result<[Country], Error>

    public init(
        getCountries: @escaping () async -> Result<[Country], Error>
    ) {
        self.getCountries = getCountries
    }
}

extension CountryListProvider {
    static let live: CountryListProvider = .init(getCountries: {
        let client = Client()
        let countriesEndpoint = URL(string: Client.countriesEndpoint)!
        let request = URLRequest(url: countriesEndpoint)
        do {
            let clientResponse = try await client.perform(request: request)
            return clientResponse.map()
        } catch {
            return .failure(error)
        }
    })
}
