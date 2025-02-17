//
//  CountryMapView.swift
//  Countries
//
//  Created by Melanija Grunte on 14/02/2025.
//

import MapKit
import SwiftUI

struct CountryMapView: View {
    let capitalName: String
    let capitalCoordinates: CLLocationCoordinate2D

    @State private var cameraPosition: MapCameraPosition

    init(capitalName: String, capitalCoordinates: CLLocationCoordinate2D) {
        self.capitalName = capitalName
        self.capitalCoordinates = capitalCoordinates
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
        cameraPosition = .region(MKCoordinateRegion(
            center: capitalCoordinates,
            span: coordinateSpan
        ))
    }

    var body: some View {
        Map(position: $cameraPosition) {
            Marker(capitalName, coordinate: capitalCoordinates)
        }
    }
}

extension Country {
    var capitalCoordinates: CLLocationCoordinate2D? {
        guard
            let latitude = capitalInfo.latlng?.get(at: 0),
            let longitude = capitalInfo.latlng?.get(at: 1)
        else { return nil }

        return .init(latitude: latitude, longitude: longitude)
    }
}

extension Collection {
    func get(at index: Index) -> Iterator.Element? {
        indices.contains(index) ? self[index] : nil
    }
}
