//
//  NeighboringCountriesView.swift
//  Countries
//
//  Created by Melanija Grunte on 14/02/2025.
//

import SwiftUI

struct NeighboringCountriesView: View {
    let country: Country
    let fullCountryList: [Country]

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Neigboring countries")
                .foregroundStyle(.gray)

            let neighboringCountries = country.neighboringCountries(countriesList: fullCountryList)

            if neighboringCountries.isEmpty {
                Text("None")
                    .foregroundStyle(.primary)
            } else {
                ForEach(neighboringCountries) { country in
                    NavigationLink(value: country) {
                        Text(country.name.official)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.vertical, 6)
                }
            }

            Divider()
        }
    }
}

extension Country {
    func neighboringCountries(countriesList: [Country]) -> [Country] {
        guard let borders else { return [] }
        return countriesList.filter { borders.contains($0.cca3) }
    }
}
