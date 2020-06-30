//
//  SearchResultTableViewCell.swift
//  MovieSearch
//
//  Created by Andrew Monshizadeh on 6/30/20.
//  Copyright © 2020 Andrew Monshizadeh. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

  lazy var movieTitleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.font = UIFont.preferredFont(forTextStyle: .headline)
    label.adjustsFontForContentSizeCategory = true
    return label
  }()

  lazy var yearLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 1
    label.font = UIFont.preferredFont(forTextStyle: .subheadline)
    label.adjustsFontForContentSizeCategory = true
    return label
  }()

  lazy var posterImage: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.widthAnchor.constraint(equalToConstant: 68).isActive = true
    view.heightAnchor.constraint(equalToConstant: 100).isActive = true
    view.backgroundColor = UIColor.darkGray
    return view
  }()

  lazy var textStackView: UIStackView = {
    let view = UIStackView(arrangedSubviews: [movieTitleLabel, yearLabel])
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .vertical
    view.alignment = .leading
    view.spacing = UIStackView.spacingUseSystem
    view.isBaselineRelativeArrangement = true
    view.distribution = .fillProportionally
    return view
  }()

  lazy var cellStackView: UIStackView = {
    let view = UIStackView(arrangedSubviews: [posterImage, textStackView])
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .horizontal
    view.alignment = .center
    view.spacing = UIStackView.spacingUseSystem
    view.distribution = .fillProportionally
    return view
  }()

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)

    contentView.addSubview(cellStackView)
    NSLayoutConstraint.activate(cellStackView.boundingConstraints(equalTo: contentView.layoutMarginsGuide))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    movieTitleLabel.text = nil
    yearLabel.text = nil
    posterImage.image = nil
  }
}
