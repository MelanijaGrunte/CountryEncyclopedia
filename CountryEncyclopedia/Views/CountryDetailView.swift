//
//  CountryDetailView.swift
//  Countries
//
//  Created by Melanija Grunte on 13/02/2025.
//

import SwiftUI

struct CountryDetailView: View {
    @ObservedObject var viewModel: CountryDetailViewModel
    @Environment(Favourites.self) var favourites

    private var simpleDetails: [(title: String, value: String)] { [
        ("Common name", viewModel.country.name.common),
        ("Official name", viewModel.country.name.official),
        ("Region", viewModel.country.region),
        ("Continents", viewModel.country.continents.joined(separator: ", ")),
        ("Country code", viewModel.country.countryCode),
        ("Population", String(describing: viewModel.country.population)),
        ("Global population rank", String(describing: viewModel.getPopulationRank())),
        ("Currencies", viewModel.country.currenciesFormatted),
    ] }

    init(viewModel: CountryDetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading) {
                ForEach(simpleDetails, id: \.title) { detail in
                    simpleInfoView(
                        title: detail.title,
                        value: detail.value
                    )
                }

                flagView

                mapView

                NeighboringCountriesView(
                    country: viewModel.country,
                    fullCountryList: viewModel.fullCountryList
                )

                LanguagesView(
                    languages: viewModel.country.languages ?? [:],
                    fullCountryList: viewModel.fullCountryList
                )

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
        }
        .navigationTitle(viewModel.country.name.official)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                favoriteButton
            }
        }
    }

    var favoriteButton: some View {
        Button(action: {
            favourites.toggle(viewModel.country)
        }, label: {
            Image(systemName: favourites.contains(viewModel.country) ? "heart.fill" : "heart")
        })
    }

    func simpleInfoView(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .foregroundStyle(.gray)
            Text(value)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
            Divider()
        }
        .padding(.top, 6)
    }

    var flagView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Flag")
                .foregroundStyle(.gray)
            AsyncImage(url: viewModel.flagUrl)
            Divider()
        }
        .padding(.top, 6)
    }

    @ViewBuilder
    var mapView: some View {
        if
            let capitalName = viewModel.country.capital?.first,
            let capitalCoordinates = viewModel.country.capitalCoordinates
        {
            Text("Capital city")
                .foregroundStyle(.gray)
                .padding(.top, 6)

            // TODO: handle countries with multiple capital cities
            CountryMapView(capitalName: capitalName, capitalCoordinates: capitalCoordinates)
                .frame(height: 200)

            Divider()
        }
    }
}
