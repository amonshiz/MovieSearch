//
//  UIView+Constraints.swift
//  MovieSearch
//
//  Created by Andrew Monshizadeh on 6/30/20.
//  Copyright © 2020 Andrew Monshizadeh. All rights reserved.
//

import UIKit

extension UIView {
    func boundingConstraints(equalTo second: BoundingAnchorDefining) -> [NSLayoutConstraint] {
        [
            self.topAnchor.constraint(equalTo: second.topAnchor),
            self.bottomAnchor.constraint(equalTo: second.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: second.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: second.trailingAnchor)
        ]
    }
}
