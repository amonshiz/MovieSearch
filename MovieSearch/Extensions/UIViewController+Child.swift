//
//  UIViewController+Child.swift
//  MovieSearch
//
//  Created by Andrew Monshizadeh on 6/30/20.
//  Copyright © 2020 Andrew Monshizadeh. All rights reserved.
//

import UIKit

extension UIViewController {
    func install(_ child: UIViewController, constraints: [NSLayoutConstraint]) {
        guard child.parent != self else { return }
        addChild(child)
        view.addSubview(child.view)
        NSLayoutConstraint.activate(constraints)
        child.didMove(toParent: self)
    }

    func uninstall(_ child: UIViewController, constraints: [NSLayoutConstraint]) {
        guard child.parent == self else { return }
        child.willMove(toParent: nil)
        child.view.removeConstraints(constraints)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}

