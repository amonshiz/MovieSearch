//
//  ResultsTableViewController.swift
//  MovieSearch
//
//  Created by Andrew Monshizadeh on 6/30/20.
//  Copyright © 2020 Andrew Monshizadeh. All rights reserved.
//

import UIKit

protocol ResultsTableViewControllerDelegate: class {
  func tableViewController(_ tableViewController: ResultsTableViewController, selected: SearchResultMovie)
}

class ResultsTableViewController: UIViewController {
  private lazy var tableView: UITableView = {
    let view = UITableView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.estimatedRowHeight = UITableView.automaticDimension

    view.register(SearchResultTableViewCell.self, forCellReuseIdentifier: String(describing:SearchResultTableViewCell.self))

    view.delegate = self
    view.dataSource = self
    return view
  }()

  var results: SearchResult? {
    didSet {
      // no idea what is going to happen so remove everything
      imageFetcher.cancelAll()
      tableView.reloadData()
    }
  }

  private let imageFetcher: ImageFetcher
  public weak var delegate: ResultsTableViewControllerDelegate?

  init(imageFetcher: ImageFetcher) {
    self.imageFetcher = imageFetcher

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(tableView)
    NSLayoutConstraint.activate(tableView.boundingConstraints(equalTo: view.safeAreaLayoutGuide))
  }
}

extension ResultsTableViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let results = results?.movies() else { return 0 }

    return results.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let results = results?.movies() else {
      fatalError("There can be no cells to dequeue if there are no results")
    }

    guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:SearchResultTableViewCell.self), for: indexPath) as? SearchResultTableViewCell else {
      fatalError("Unable to dequeue expected cell type")
    }

    // configure the labels as they are ready immediately
    let result = results[indexPath.row]
    let imdbID = result.imdbID
    cell.movieTitleLabel.text = result.title
    cell.yearLabel.text = result.year

    // begin querying for the poster image
    if let posterURL = result.posterURL {
      imageFetcher.fetch(posterURL) { [weak self] image in
        guard let self = self else { return }

        DispatchQueue.main.async {
          // get the current results and ensure they are valid for display
          guard let results = self.results?.movies() else { return }

          // ensure that the movie originally requested is still in the
          // collection of movies still being displayed
          guard let index = results.firstIndex(where: { movie -> Bool in
            movie.imdbID == imdbID
          }) else { return }

          let innerIndexPath = IndexPath(row: index, section: 0)
          guard let innerCell = self.tableView.cellForRow(at: innerIndexPath) as? SearchResultTableViewCell else { return }
          
          innerCell.posterImage.image = image
        }
      }
    }
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let results = results?.movies()
      , results.count > indexPath.row else {
        return
    }

    delegate?.tableViewController(self, selected: results[indexPath.row])
  }

  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let results = results?.movies()
      , results.count > indexPath.row else {
        return
    }

    let result = results[indexPath.row]
    if let posterURL = result.posterURL {
      imageFetcher.cancelFetch(for: posterURL)
    }
  }
}
