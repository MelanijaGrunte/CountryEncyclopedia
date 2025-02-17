//
//  LanguagesView.swift
//  Countries
//
//  Created by Melanija Grunte on 14/02/2025.
//

import SwiftUI

struct LanguagesView: View {
    let languages: [String: String]
    let fullCountryList: [Country]

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Languages").foregroundStyle(.gray)

            ForEach(languages.asIdentifiable) { language in
                NavigationLink(value: language) {
                    Text(language.name).foregroundStyle(.primary)
                }
                .padding(.vertical, 6)
            }

            Divider()
        }
    }
}

struct Language: Identifiable, Hashable {
    let id: Int
    let code: String
    let name: String
}

extension Dictionary where Key == String, Value == String {
    var asIdentifiable: [Language] {
        enumerated().map { index, element in
            Language(
                id: index,
                code: element.key,
                name: element.value
            )
        }
    }
}
