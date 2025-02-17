//
//  CountryEncyclopediaApp.swift
//  CountryEncyclopedia
//
//  Created by Melanija Grunte on 13/02/2025.
//

import SwiftUI

@main
struct CountryEncyclopediaApp: App {
    var body: some Scene {
        WindowGroup {
            CountryListView(viewModel: CountryListViewModel(countryListProvider: .live))
        }
    }
}
