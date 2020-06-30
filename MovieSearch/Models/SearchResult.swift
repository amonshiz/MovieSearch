//
//  SearchResult.swift
//  MovieSearch
//
//  Created by Andrew Monshizadeh on 6/30/20.
//  Copyright © 2020 Andrew Monshizadeh. All rights reserved.
//

import Foundation

enum SearchResult: Codable {
  case success(totalResults: String, search: [SearchResultMovie])
  case error(error: String)

  private enum CodingKeys: String, CodingKey {
    case search = "Search"
    case response = "Response"
    case error = "Error"

    case totalResults // default value is fine
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    let response = try values.decode(String.self, forKey: CodingKeys.response)

    switch response {
      case "True":
        let totalResults = try values.decode(String.self, forKey: CodingKeys.totalResults)
        let search = try values.decode([SearchResultMovie].self, forKey: CodingKeys.search)
        self = .success(totalResults: totalResults, search: search)
      default:
        let errorString = try values.decode(String.self, forKey: CodingKeys.error)
        self = .error(error: errorString)
    }
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
      case let .success(totalResults, search):
        try container.encode("True", forKey: CodingKeys.response)
        try container.encode(totalResults, forKey: CodingKeys.totalResults)
        try container.encode(search, forKey: CodingKeys.search)
      case let .error(error):
        try container.encode("False", forKey: CodingKeys.response)
        try container.encode(error, forKey: CodingKeys.error)
    }
  }
}

struct SearchResultMovie: Codable {
  let title: String
  let year: String
  let imdbID: String
  let type: String
  let posterURL: URL?

  private enum CodingKeys: String, CodingKey {
    case title = "Title"
    case year = "Year"
    case type = "Type"
    case posterURL = "Poster"

    case imdbID // fine
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.title = try values.decode(String.self, forKey: CodingKeys.title)
    self.year = try values.decode(String.self, forKey: CodingKeys.year)
    self.imdbID = try values.decode(String.self, forKey: CodingKeys.imdbID)
    self.type = try values.decode(String.self, forKey: CodingKeys.type)

    let posterURL = try values.decode(String.self, forKey: CodingKeys.posterURL)
    switch posterURL {
      case "N/A":
        self.posterURL = nil
      default:
        self.posterURL = URL(string: posterURL)
    }
  }
}
