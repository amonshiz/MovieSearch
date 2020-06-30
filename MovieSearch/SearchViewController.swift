//
//  ViewController.swift
//  MovieSearch
//
//  Created by Andrew Monshizadeh on 6/30/20.
//  Copyright © 2020 Andrew Monshizadeh. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
  //MARK: - Child View Controller management
  private enum ChildViewController {
    case empty, loading, results
  }

  private enum ChildDisplayAction {
    case show, hide
  }

  //MARK: - Members
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

  private lazy var loadingViewController: LoadingViewController = {
    LoadingViewController()
  }()
  private lazy var loadingConstraints: [NSLayoutConstraint] = {
    loadingViewController.view.boundingConstraints(equalTo: view.safeAreaLayoutGuide)
  }()

  private lazy var resultsTableViewController: ResultsTableViewController = {
    ResultsTableViewController()
  }()
  private lazy var resultsConstraints: [NSLayoutConstraint] = {
    resultsTableViewController.view.boundingConstraints(equalTo: view.safeAreaLayoutGuide)
  }()

  private let searchResultFetcher: MovieSearchResultFetching

  //MARK: - Lifecycle
  init(searchResultFetcher: MovieSearchResultFetching) {
    self.searchResultFetcher = searchResultFetcher

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Movies"
    self.navigationItem.searchController = searchController

    take(action: .show, for: .empty)
  }

}

//MARK: - Child View Controller Extension
extension SearchViewController {
  private func take(action: ChildDisplayAction, for viewController: ChildViewController) {
    let child: UIViewController
    let constraints: [NSLayoutConstraint]
    switch viewController {
      case .empty:
        child = emptyStateViewController
        constraints = emptyStateContraints
      case .loading:
        child = loadingViewController
        constraints = loadingConstraints
      case .results:
        child = resultsTableViewController
        constraints = resultsConstraints
    }

    let functionToApply: (UIViewController, [NSLayoutConstraint]) -> ()
    switch action {
      case .show:
        functionToApply = install
      case .hide:
        functionToApply = uninstall
    }

    functionToApply(child, constraints)
  }
}

//MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text
      , text.count > 0 else {
        take(action: .hide, for: .loading)
        take(action: .hide, for: .results)
        take(action: .show, for: .empty)
        return
    }

    // User has entered text, so start the spinner and start a search
    take(action: .hide, for: .empty)
    take(action: .show, for: .loading)
    searchResultFetcher.fetchMovies(matching: text) { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }

        self.take(action: .hide, for: .loading)
        switch result.search.count {
          case 0:
            self.take(action: .show, for: .empty)

          default:
            self.take(action: .show, for: .results)
        }

        self.resultsTableViewController.results = result
      }
    }
  }
}

