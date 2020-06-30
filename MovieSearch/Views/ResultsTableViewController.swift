//
//  ResultsTableViewController.swift
//  MovieSearch
//
//  Created by Andrew Monshizadeh on 6/30/20.
//  Copyright © 2020 Andrew Monshizadeh. All rights reserved.
//

import UIKit

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
      tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}

extension ResultsTableViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let results = results else { return 0 }
    return results.search.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let results = results else {
      fatalError("There can be no cells to dequeue if there are no results")
    }

    guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:SearchResultTableViewCell.self), for: indexPath) as? SearchResultTableViewCell else {
      fatalError("Unable to dequeue expected cell type")
    }

    let result = results.search[indexPath.row]
    cell.movieTitleLabel.text = result.title
    cell.yearLabel.text = result.year
    return cell
  }
}
