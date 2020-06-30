//
//  SearchResult.swift
//  MovieSearch
//
//  Created by Andrew Monshizadeh on 6/30/20.
//  Copyright © 2020 Andrew Monshizadeh. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
  let totalResults: String
  let search: [SearchResultMovie]
  let response: String

  private enum CodingKeys: String, CodingKey {
    case search = "Search"
    case response = "Response"

    case totalResults // default value is fine
  }
}

struct SearchResultMovie: Codable {
  let title: String
  let year: String
  let imdbID: String
  let type: String
  let posterURL: URL

  private enum CodingKeys: String, CodingKey {
    case title = "Title"
    case year = "Year"
    case type = "Type"
    case posterURL = "Poster"

    case imdbID // fine
  }
}
