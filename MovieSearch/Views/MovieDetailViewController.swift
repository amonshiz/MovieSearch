//
//  MovieDetailViewController.swift
//  MovieSearch
//
//  Created by Andrew Monshizadeh on 6/30/20.
//  Copyright © 2020 Andrew Monshizadeh. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
  private lazy var posterImage: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    return view
  }()

  lazy var movieTitleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.font = UIFont.preferredFont(forTextStyle: .headline)
    label.adjustsFontForContentSizeCategory = true
    return label
  }()

  private func ratingLabel(for text: String) -> UIView {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = text
    label.adjustsFontForContentSizeCategory = true
    label.numberOfLines = 0
    label.font = UIFont.preferredFont(forTextStyle: .body)
    return label
  }

  private func ratingView(for rating: Rating) -> UIView {
    let sourceLabel = ratingLabel(for: rating.source)
    let valueLabel = ratingLabel(for: rating.value)

    let stackView = UIStackView(arrangedSubviews: [sourceLabel, valueLabel])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.spacing = UIStackView.spacingUseSystem
    stackView.distribution = .fillProportionally

    return stackView
  }

  private lazy var ratingsStackView: UIStackView = {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .vertical
    view.alignment = .leading
    view.spacing = UIStackView.spacingUseSystem
    view.isBaselineRelativeArrangement = true
    view.distribution = .fillProportionally
    return view
  }()

  private lazy var textStackView: UIStackView = {
    let view = UIStackView(arrangedSubviews: [movieTitleLabel , ratingsStackView])
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .vertical
    view.alignment = .leading
    view.spacing = UIStackView.spacingUseSystem
    view.distribution = .fillProportionally
    return view
  }()

  private lazy var contentView: UIStackView = {
    let view = UIStackView(arrangedSubviews: [posterImage , textStackView])
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .vertical
    view.alignment = .leading
    view.spacing = UIStackView.spacingUseSystem
    view.distribution = .fill
    return view
  }()

  private lazy var scrollView: UIScrollView = {
    let view = UIScrollView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(contentView)
    view.backgroundColor = .clear
    return view
  }()

  private var details: MovieDetail? {
    didSet {
      guard let details = self.details
        , case let MovieDetail.success(title, ratings, maybePosterURL) = details else { return }

      DispatchQueue.main.async {
        self.movieTitleLabel.text = title
        ratings.map(self.ratingView(for:)).forEach(self.ratingsStackView.addArrangedSubview(_:))

        self.view.setNeedsUpdateConstraints()
      }

      guard let posterURL = maybePosterURL else { return }
      self.imageFetcher.fetch(posterURL) { [weak self] image in
        DispatchQueue.main.async {
          guard let self = self else { return }
          self.posterImage.image = image

          self.view.setNeedsUpdateConstraints()
        }
      }
    }
  }

  private let movieTitle: String
  private var detailFetcher: MovieDetailFetching
  private let imageFetcher: ImageFetcher

  init(for movieTitle: String,
       detailFetcher: MovieDetailFetching,
       imageFetcher: ImageFetcher) {
    self.movieTitle = movieTitle
    self.detailFetcher = detailFetcher
    self.imageFetcher = imageFetcher

    super.init(nibName: nil, bundle: nil)

    self.title = movieTitle
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground

    view.addSubview(scrollView)
    NSLayoutConstraint.activate([
      scrollView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 1.0),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: scrollView.trailingAnchor, multiplier: 1.0),
      scrollView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0),
      view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: scrollView.bottomAnchor, multiplier: 1.0),
    ])
        NSLayoutConstraint.activate(contentView.boundingConstraints(equalTo: scrollView))
    NSLayoutConstraint.activate([
      textStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
    ])

    detailFetcher.delegate = self
    detailFetcher.fetch(movie: movieTitle)
  }

  override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    coordinator.animate(alongsideTransition: { context in
      self.view.setNeedsUpdateConstraints()
    }, completion: nil)
  }
}

extension MovieDetailViewController: MovieDetailUpdating {
  func update(with results: MovieDetail) {
    self.details = results
  }
}
