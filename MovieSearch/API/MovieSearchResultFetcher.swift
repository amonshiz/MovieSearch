//
//  MovieSearchResultFetcher.swift
//  MovieSearch
//
//  Created by Andrew Monshizadeh on 6/30/20.
//  Copyright © 2020 Andrew Monshizadeh. All rights reserved.
//

import Foundation

protocol MovieSearchResultFetching {
  typealias CompletionHandler = (SearchResult) -> ()
  func fetchMovies(matching: String, _ completion: @escaping CompletionHandler)
}

class MovieSearchResultFetcher: MovieSearchResultFetching {
  private let apiService: MovieSearchService

  init(service: MovieSearchService) {
    self.apiService = service
  }

  func fetchMovies(matching: String, _ completion: @escaping CompletionHandler) {
    apiService.fetchMovies(matching: matching) { data in
      var resultToReturn = SearchResult.success(totalResults: "0", search: [])

      defer {
        completion(resultToReturn)
      }

      if let data = data {
        let decoder = JSONDecoder()
        do {
          resultToReturn = try decoder.decode(SearchResult.self, from: data)
        } catch {
          print("Error decoding: \(error)")
        }
      }
    }
  }
}
