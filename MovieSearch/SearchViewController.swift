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

  private lazy var emptyStateViewController: EmptyStateViewController = {
    EmptyStateViewController()
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    self.title = "Movies"

    self.navigationItem.searchController = searchController

    install(emptyStateViewController, constraints: [
      emptyStateViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      emptyStateViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      emptyStateViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      emptyStateViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }

}

extension SearchViewController: UISearchResultsUpdating {
  func updateSearchResults(for: UISearchController) {

  }
}

