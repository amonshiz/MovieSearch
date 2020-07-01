//
//  MovieDetail.swift
//  MovieSearch
//
//  Created by Andrew Monshizadeh on 6/30/20.
//  Copyright © 2020 Andrew Monshizadeh. All rights reserved.
//

import Foundation

enum MovieDetail: Decodable {
  case success(title: String, ratings: [Rating], posterURL: URL?)
  case error(error: String)
  
  private enum CodingKeys: String, CodingKey {
    case title = "Title"
    case ratings = "Ratings"
    case posterURL = "Poster"
    case error = "Error"
    case response = "Response"
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    let response = try values.decode(String.self, forKey: CodingKeys.response)
    
    switch response {
      case "True":
        let title = try values.decode(String.self, forKey: CodingKeys.title)
        let ratings = try values.decode([Rating].self, forKey: CodingKeys.ratings)
        let posterURLString = try values.decode(String.self, forKey: CodingKeys.posterURL)
        let posterURL: URL?
        switch posterURLString {
          case "N/A":
            posterURL = nil
          default:
            posterURL = URL(string: posterURLString)
        }
        
        self = .success(title: title, ratings: ratings, posterURL: posterURL)
      default:
        let errorString = try values.decode(String.self, forKey: CodingKeys.error)
        self = .error(error: errorString)
    }
  }
}

extension MovieDetail {
  func ratings() -> [Rating]? {
    switch self {
      case let .success(_, ratings, _):
        return ratings
      case .error:
        return nil
    }
  }
  
  func posterURL() -> URL? {
    switch self {
      case let .success(_, _, posterURL):
        return posterURL
      case .error:
        return nil
    }
  }
}

struct Rating: Decodable {
  let source: String
  let value: String
  
  private enum CodingKeys: String, CodingKey {
    case source = "Source"
    case value = "Value"
  }
}
