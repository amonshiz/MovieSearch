//
//  ImageFetcher.swift
//  MovieSearch
//
//  Created by Andrew Monshizadeh on 6/30/20.
//  Copyright © 2020 Andrew Monshizadeh. All rights reserved.
//

import UIKit

class ImageFetcher {
  public static let shared = ImageFetcher()

  private let defaultSession: URLSession

  private var urlMap = [URL:URLSessionDataTask]()
  private let mapQueue = DispatchQueue(label: "com.amonshiz.MovieSearch.ImageFetchQueue", qos: .userInteractive)

  init() {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .returnCacheDataElseLoad
    defaultSession = URLSession(configuration: configuration)
  }

  private func mapContains(url: URL) -> Bool {
    var value: Bool = false
    mapQueue.sync {
      value = urlMap.keys.contains(url)
    }

    return value
  }

  private func add(_ dataTask: URLSessionDataTask, forKey key: URL) {
    mapQueue.async {
      self.urlMap[key] = dataTask
    }
  }

  private func remove(forKey key: URL) {
    mapQueue.async {
      self.urlMap.removeValue(forKey: key)
    }
  }

  func fetch(_ url: URL, _ completion: @escaping (UIImage?) -> ()) {
    // this places a synchronous check on the mapQueue which
    // is itself a serial queue. thus the check will only happen
    // after any existing add or removes have completed
    guard !mapContains(url: url) else {
      // already fetching so just let it finish
      return
    }

    let dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
      var imageToUse: UIImage? = nil

      defer {
        completion(imageToUse)
        self?.remove(forKey: url)
      }

      guard error == nil else {
        return
      }

      guard let data = data
          , data.count > 0 else {
          return
      }

      imageToUse = UIImage(data: data)
    }

    add(dataTask, forKey: url)
    dataTask.resume()
  }

  func cancelFetch(for url: URL) {
    mapQueue.async {
      guard let dataTask = self.urlMap[url] else {
        return
      }

      dataTask.cancel()
      self.remove(forKey: url)
    }
  }

  func cancelAll() {
    mapQueue.async {
      for (_, dataTask) in self.urlMap {
        dataTask.cancel()
      }

      self.urlMap.removeAll()
    }
  }
}
