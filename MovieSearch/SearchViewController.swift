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

  private var emptyStateViewController: EmptyStateViewController!
  private lazy var emptyStateContraints: [NSLayoutConstraint] = {
    emptyStateViewController.view.boundingConstraints(equalTo: view.safeAreaLayoutGuide)
  }()

  private var loadingViewController: LoadingViewController!
  private lazy var loadingConstraints: [NSLayoutConstraint] = {
    loadingViewController.view.boundingConstraints(equalTo: view.safeAreaLayoutGuide)
  }()

  private var resultsTableViewController: ResultsTableViewController!
  private lazy var resultsConstraints: [NSLayoutConstraint] = {
    resultsTableViewController.view.boundingConstraints(equalTo: view.safeAreaLayoutGuide)
  }()

  private var searchResultFetcher: MovieSearchResultFetching
  private let imageFetcher: ImageFetcher
  private let keyboardObserver: KeyboardObserver
  private let typingDebouncer: DebouncerInterface

  //MARK: - Lifecycle
  init(searchResultFetcher: MovieSearchResultFetching,
       imageFetcher: ImageFetcher,
       keyboardObserver: KeyboardObserver,
       debouncer: DebouncerInterface = NSObjectPerformDebouncer(interval: 0.25)) {
    self.searchResultFetcher = searchResultFetcher
    self.imageFetcher = imageFetcher
    self.keyboardObserver = keyboardObserver
    self.typingDebouncer = debouncer

    emptyStateViewController = EmptyStateViewController()
    loadingViewController = LoadingViewController()
    resultsTableViewController = ResultsTableViewController(imageFetcher: imageFetcher)

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Movies"
    self.navigationItem.searchController = searchController

    searchResultFetcher.delegate = self

    typingDebouncer.add { [weak self] in
      guard let self = self else { return }
      self.searchResultFetcher.fetchMovies(matching: self.searchController.searchBar.text)
    }

    keyboardObserver.add { [weak self] info in
      guard let self = self else { return }
      // convert rects to same coordinate space
      let convertedView = self.view.convert(self.view.frame, to: nil)
      let convertedKeyboard = self.view.convert(info.futureFrame, to: nil)
      // intersect keyboard with view
      let intersection = convertedView.intersection(convertedKeyboard)
      var insets = self.additionalSafeAreaInsets
      insets.bottom = intersection.isNull ? 0 : intersection.height
      self.additionalSafeAreaInsets = insets
    }

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
        self.resultsTableViewController.results = nil
        return
    }

    // User has entered text, so start the spinner and start a search
    take(action: .hide, for: .empty)
    take(action: .hide, for: .results)
    take(action: .show, for: .loading)
    typingDebouncer.trigger()
  }
}

extension SearchViewController: MovieSearchResultUpdating {
  func update(with results: SearchResult) {
    DispatchQueue.main.async {
      self.take(action: .hide, for: .loading)
      switch results {
        case let .success(_, search):
          switch search.count {
            case 0:
              self.take(action: .show, for: .empty)

            default:
              self.take(action: .show, for: .results)
        }
        case .error:
          self.take(action: .show, for: .empty)
      }

      self.resultsTableViewController.results = results
    }
  }
}

