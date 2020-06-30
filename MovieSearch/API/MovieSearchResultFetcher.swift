//
//  MovieSearchResultFetcher.swift
//  MovieSearch
//
//  Created by Andrew Monshizadeh on 6/30/20.
//  Copyright © 2020 Andrew Monshizadeh. All rights reserved.
//

import Foundation

protocol MovieSearchResultUpdating: class {
  func update(with results: SearchResult) -> ()
}

protocol MovieSearchResultFetching {
  func fetchMovies(matching: String?)

  var delegate: MovieSearchResultUpdating? { get set }
}

class MovieSearchResultFetcher: MovieSearchResultFetching {
  private let apiService: MovieSearchService
  public weak var delegate: MovieSearchResultUpdating?

  init(service: MovieSearchService) {
    self.apiService = service
  }

  func fetchMovies(matching: String?) {
    var resultToReturn = SearchResult.success(totalResults: "0", search: [])

    guard let query = matching, query.count > 0 else {
      self.delegate?.update(with: resultToReturn)
      return
    }

    apiService.fetchMovies(matching: query) { [weak self] data in
      guard let self = self else { return }
      defer {
        self.delegate?.update(with: resultToReturn)
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
