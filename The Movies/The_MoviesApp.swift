//
//  The_MoviesApp.swift
//  The Movies
//
//  Created by Fabian Hofmann on 27.10.22.
//

import SwiftUI

@main
struct The_MoviesApp: App {
    
    // Used for dependency injection of stores and services
    let moviesStore: MovieDataStore = MovieDataStore()
    let movieApiService: MovieApiService = MovieApiService()
    
    let movieDataPublisher: MovieDataPublisher = MovieDataPublisher()
    let movieDataStore: MovieDataStore = MovieDataStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(moviesStore)
                .environmentObject(movieApiService)
                .environmentObject(movieDataPublisher)
                .environmentObject(movieDataStore)
    
        }
    }
}
