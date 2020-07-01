//
//  MovieDetailFetcher.swift
//  MovieSearch
//
//  Created by Andrew Monshizadeh on 6/30/20.
//  Copyright © 2020 Andrew Monshizadeh. All rights reserved.
//

import Foundation

protocol MovieDetailUpdating: class {
  func update(with results: MovieDetail) -> ()
}

protocol MovieDetailFetching {
  func fetch(movie: String)

  var delegate: MovieDetailUpdating? { get set }
}

class MovieDetailFetcher: MovieDetailFetching {
  private let service: MovieDetailService
  public weak var delegate: MovieDetailUpdating?

  init(service: MovieDetailService) {
    self.service = service
  }

  func fetch(movie: String) {
    guard !movie.isEmpty else { return }

    service.fetch(movie: movie) { [weak self] data in
      guard let self = self else { return }
      var resultToReturn: MovieDetail = .error(error: "Unable to generate details")
      defer {
        self.delegate?.update(with: resultToReturn)
      }

      guard let data = data else { return }

      let decoder = JSONDecoder()
      do {
        resultToReturn = try decoder.decode(MovieDetail.self, from: data)
      } catch {
        print("Error decoding movie detail: \(error)")
      }
    }
  }
}
