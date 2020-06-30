//
//  OMDBAPIService.swift
//  MovieSearch
//
//  Created by Andrew Monshizadeh on 6/30/20.
//  Copyright © 2020 Andrew Monshizadeh. All rights reserved.
//

import Foundation

protocol MovieSearchService {
  typealias SearchResultCallback = (Data?) -> ()
  func fetchMovies(matching: String, _ completion: @escaping SearchResultCallback) -> ()
}

final class OMDBAPIService: MovieSearchService {
  /*
   Singleton instance that will be used through out the app, though this
   specific refrence should only be used at the top most point possible and then
   passed down to any necessary users.
   */
  static public let shared = OMDBAPIService()

  /// API's base URL
  private static let baseURLString = "http://www.omdbapi.com"
  /**
   API Key
   This is not a good practice, but for this it will work. A more "secure"
   option is to not commit it to source control and to obfuscate it in some
   way. But really, client side secrets are never going to be too secure.
   */
  private static let apiKey = URLQueryItem(name: "apikey", value: "fb2aae1d")

  private let urlSession = URLSession(configuration: .default)

  func fetchMovies(matching: String, _ completion: @escaping SearchResultCallback) {
    guard var urlComponents = URLComponents(string: OMDBAPIService.baseURLString) else {
      fatalError("baseURLString unable to create url components")
    }
    let queryParameter = URLQueryItem(name: "s", value: matching)
    urlComponents.queryItems = [
      OMDBAPIService.apiKey,
      queryParameter,
    ]

    guard let finalURL = urlComponents.url else {
      fatalError("Unable to make valid URL from components and query item")
    }

    let dataTask = urlSession.dataTask(with: finalURL) { data, response, error in
      guard error == nil else {
        completion(nil)
        return
      }

      guard let httpResponse = response as? HTTPURLResponse
        , httpResponse.statusCode == 200
        , let data = data else {
        completion(nil)
        return
      }

      completion(data)
    }

    dataTask.resume()
  }
}
