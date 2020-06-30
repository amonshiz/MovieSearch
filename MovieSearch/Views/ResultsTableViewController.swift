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

    view.delegate = self
    view.dataSource = self
    return view
  }()

  var results: SearchResult? = nil

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

    guard let fileURL = Bundle.main.url(forResource: "SampleSearch", withExtension: "json")
      , let string = try? String(contentsOf: fileURL, encoding: .utf8)
      , let data = string.data(using: .utf8) else {
        return
    }

    do {
      results = try JSONDecoder().decode(SearchResult.self, from: data)
    } catch {
      print("Decoding error: \(error)")
    }

    tableView.reloadData()
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
    let result = results.search[indexPath.row]
    let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
    cell.textLabel?.text = result.title
    return cell
  }
}
