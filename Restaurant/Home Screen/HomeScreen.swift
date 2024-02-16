//
//  HomeScreen.swift
//  Restaurant
//
//  Created by John Tejada on 2/10/24.
//

import SwiftUI
import MapKit
import CoreLocationUI
import Foundation

struct HomeScreen: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var favoriteCuisine: String = ""
    @State private var showingLocationButton = true
    @State private var showingResults = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                .ignoresSafeArea()
            
            VStack {
                
                
                if !showingLocationButton {
                    TextField("Enter favorite cuisine", text: $favoriteCuisine)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Search") {
                        viewModel.searchForCuisine(cuisine: favoriteCuisine)
                        showingResults = true
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                if showingLocationButton {
                    LocationButton(.currentLocation) {
                        viewModel.requestAllowOnceLocationPermission()
                        showingLocationButton = false
                    }
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .labelStyle(.titleAndIcon)
                    .padding(.bottom, 50)
                }
                
               
                if !showingLocationButton {
                    NavigationLink(destination: ResultsScreen(results: viewModel.searchResults), isActive: $showingResults) {
                        EmptyView()
                    }
                    .hidden()
                }
                
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text ("Find Restaurants")
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: PhotoScreen()) {
                    Text("Next")
                }
            }
        }
    }
}
    
    final class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        // To update the map's region in the UI
        @Published var region: MKCoordinateRegion
        // To hold search results
        @Published var searchResults: [MKMapItem] = []
        
        // To manage location updates
        let locationManager = CLLocationManager()
        
        override init() {
            // For Demo initilized to Bay Area.
            self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            super.init()
            
            // Set up the location manager
            locationManager.delegate = self
            // Request permission to use location services
            locationManager.requestWhenInUseAuthorization()
            // Start updating the location.
            locationManager.startUpdatingLocation()
        }
        
        // Function to request the current location
        func requestAllowOnceLocationPermission() {
            locationManager.requestLocation()
        }
        
        // Function to perform a search based on the user's cuisine preference
        func searchForCuisine(cuisine: String) {
            guard let userLocation = locationManager.location else {
                print("User location is not available.")
                return
            }
            
            // Create and configure a search request
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = cuisine
            // Use a region centered around the user's current location
            let searchRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
            request.region = searchRegion
            
            // Perform the search
            let search = MKLocalSearch(request: request)
            search.start { [weak self] response, _ in
                guard let self = self, let response = response else {
                    print("No results found or there was an error.")
                    return
                }
                
                // Sort the results by closest and take the closest 3
                let sortedResults = response.mapItems.sorted {
                    $0.placemark.location?.distance(from: userLocation) ?? Double.greatestFiniteMagnitude <
                        $1.placemark.location?.distance(from: userLocation) ?? Double.greatestFiniteMagnitude
                }
                
                DispatchQueue.main.async {
                    self.searchResults = Array(sortedResults.prefix(3))
                }
            }
        }
        
        // CLLocationManagerDelegate methods to handle location updates
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let latestLocation = locations.first else {
                print("Error: Failed to get user location")
                return
            }
            
            // Update the region to center the map on the user's current location
            DispatchQueue.main.async {
                self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Failed with error: \(error.localizedDescription)")
        }
        
        // Additional method to handle when the user changes authorization status
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                manager.startUpdatingLocation()
            default:
                
                break
            }
        }
    }


#Preview {
    HomeScreen()
}
