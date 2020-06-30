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
  private lazy var emptyStateContraints: [NSLayoutConstraint] = {
    [
      emptyStateViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      emptyStateViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      emptyStateViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      emptyStateViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ]
  }()
  private func showEmptyState() {
    install(emptyStateViewController, constraints: emptyStateContraints)
  }
  private func hideEmptyState() {
    uninstall(emptyStateViewController, constraints: emptyStateContraints)
  }

  private lazy var loadingViewController: LoadingViewController = {
    LoadingViewController()
  }()
  private lazy var loadingConstraints: [NSLayoutConstraint] = {
    [
      loadingViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      loadingViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      loadingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      loadingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ]
  }()
  private func showLoading() {
    install(loadingViewController, constraints: loadingConstraints)
  }
  private func hideLoading() {
    uninstall(loadingViewController, constraints: loadingConstraints)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Movies"
    self.navigationItem.searchController = searchController

//    showEmptyState()
    showLoading()
  }

}

extension SearchViewController: UISearchResultsUpdating {
  func updateSearchResults(for: UISearchController) {

  }
}

