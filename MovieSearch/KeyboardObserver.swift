//
//  KeyboardObserver.swift
//  MovieSearch
//
//  Created by Andrew Monshizadeh on 6/30/20.
//  Copyright © 2020 Andrew Monshizadeh. All rights reserved.
//

import UIKit

class KeyboardObserver {
    struct KeyboardInfo {
        let previousFrame: CGRect
        let futureFrame: CGRect
        let duration: Float
        let animationCurve: UIView.AnimationCurve
    }

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    typealias KeyboardHandler = (KeyboardInfo) -> ()
    private var handlers = [KeyboardHandler]()
    func add(_ handler: @escaping KeyboardHandler) {
        handlers.append(handler)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        handlers.removeAll()
    }

    @objc func keyboardChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            fatalError("There was no user info with the keyboard notification, that makes no sense")
        }
        let previousFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.null
        let futureFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.null
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue ?? 0
        let animationCurve = UIView.AnimationCurve(rawValue: (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0)) ?? .linear
        let info = KeyboardInfo(previousFrame: previousFrame, futureFrame: futureFrame, duration: duration, animationCurve: animationCurve)
        handlers.forEach { h in
            h(info)
        }
    }
}
