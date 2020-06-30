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
    controller.obscuresBackgroundDuringPresentation = false
    return controller
  }()

  private lazy var emptyStateViewController: EmptyStateViewController = {
    EmptyStateViewController()
  }()
  private lazy var emptyStateContraints: [NSLayoutConstraint] = {
    emptyStateViewController.view.boundingConstraints(equalTo: view.safeAreaLayoutGuide)
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
    loadingViewController.view.boundingConstraints(equalTo: view.safeAreaLayoutGuide)
  }()
  private func showLoading() {
    install(loadingViewController, constraints: loadingConstraints)
  }
  private func hideLoading() {
    uninstall(loadingViewController, constraints: loadingConstraints)
  }

  private lazy var resultsTableViewController: ResultsTableViewController = {
    ResultsTableViewController()
  }()
  private lazy var resultsConstraints: [NSLayoutConstraint] = {
    resultsTableViewController.view.boundingConstraints(equalTo: view.safeAreaLayoutGuide)
  }()
  private func showResults() {
    install(resultsTableViewController, constraints: resultsConstraints)
  }
  private func hideResults() {
    uninstall(resultsTableViewController, constraints: resultsConstraints)
  }

  private let apiService: MovieSearchService

  init(searchService: MovieSearchService) {
    apiService = searchService

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Movies"
    self.navigationItem.searchController = searchController

    showEmptyState()
  }

}

extension SearchViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text
      , text.count > 0 else {
        hideLoading()
        hideResults()
        showEmptyState()
        return
    }

    // User has entered text, so start the spinner and start a search
    hideEmptyState()
    showLoading()
    apiService.fetchMovies(matching: text) { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }

        self.hideLoading()
        switch result {
          case .none:
            self.showEmptyState()
          case .some(_):
            self.showResults()
        }

        self.resultsTableViewController.results = result
      }
    }
  }
}

