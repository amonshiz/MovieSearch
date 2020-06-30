//
//  ViewController.swift
//  MovieSearch
//
//  Created by Andrew Monshizadeh on 6/30/20.
//  Copyright © 2020 Andrew Monshizadeh. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
  private lazy var searchController: UISearchController = {
    let controller = UISearchController()
    controller.searchResultsUpdater = self
    return controller
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    self.title = "Movies"

    self.navigationItem.searchController = searchController
  }

}

extension SearchViewController: UISearchResultsUpdating {
  func updateSearchResults(for: UISearchController) {

  }
}

