//
//  CountryListView.swift
//  Countries
//
//  Created by Melanija Grunte on 13/02/2025.
//

import SwiftUI

enum CountriesListViewState {
    case loading
    case failure(Error)
    case loaded([Country])
    case search([Country])
    case favorites([Country])
}

struct CountryListView: View {
    @ObservedObject var viewModel: CountryListViewModel
    @State private var searchIsActive = false

    init(viewModel: CountryListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        varyingBody
            .environment(viewModel.favourites)
            .task {
                await viewModel.loadList()
            }
    }

    @ViewBuilder
    var varyingBody: some View {
        switch viewModel.viewState {
        case .loading:
            loadingView
        case let .failure(error):
            errorView(error: error)
        case let .loaded(array), let .search(array):
            loadedView(countries: array)
        case let .favorites(array):
            loadedView(countries: array, isFavouriteList: true)
        }
    }

    var loadingView: some View {
        ProgressView()
    }

    func errorView(error: Error) -> some View {
        Text(error.localizedDescription)
    }

    func loadedView(countries: [Country], isFavouriteList: Bool = false) -> some View {
        NavigationStack {
            List(countries) { country in
                NavigationLink(value: country) {
                    Text("\(country.flag) \(country.name.official)")
                }
            }
            .navigationDestination(for: Country.self, destination: { country in
                CountryDetailView(viewModel: CountryDetailViewModel(country: country, fullCountryList: viewModel.fullCountryList))
            })
            .navigationDestination(for: Language.self, destination: { language in
                CountriesByLanguageView(viewModel: CountriesByLanguageViewModel(languageCode: language.code, languageName: language.name, fullCountryList: viewModel.fullCountryList))
            })
            .navigationBarTitle(navigationBarTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        if isFavouriteList {
                            viewModel.closeFavourites()
                        } else {
                            viewModel.loadFavourites()
                        }
                    }, label: {
                        let imageName = isFavouriteList ? "heart.text.square.fill" : "heart.text.square"
                        Image(systemName: imageName)
                    })
                }
            }
            .onAppear(perform: {
                if case .favorites = viewModel.viewState {
                    viewModel.loadFavourites()
                }
            })
        }
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer)
    }

    var navigationBarTitle: String {
        if case .favorites = viewModel.viewState {
            return "Favourite countries"
        } else {
            return "Countries"
        }
    }
}
