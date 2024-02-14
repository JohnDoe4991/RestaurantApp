//
//  ResultsScreen.swift
//  Restaurant
//
//  Created by John Tejada on 2/13/24.
//

import SwiftUI
import MapKit

struct ResultsScreen: View {
    var results: [MKMapItem]
    
    var body: some View {
        List(results, id: \.self) { item in
            VStack(alignment: .leading) {
                Text(item.name ?? "Unknown")
                Text(item.placemark.title ?? "")
            }
        }
        .navigationTitle("Results")
    }
}


