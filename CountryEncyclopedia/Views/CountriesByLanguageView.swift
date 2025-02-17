//
//  CountriesByLanguageView.swift
//  Countries
//
//  Created by Melanija Grunte on 13/02/2025.
//

import SwiftUI

struct CountriesByLanguageView: View {
    @ObservedObject var viewModel: CountriesByLanguageViewModel

    init(viewModel: CountriesByLanguageViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List(viewModel.countries) { country in
            NavigationLink(value: country) {
                Text(country.name.official)
            }
        }
        .onAppear(perform: viewModel.loadCountriesByLanguage)
        .navigationTitle("Countries that speak \(viewModel.languageName)")
    }
}
