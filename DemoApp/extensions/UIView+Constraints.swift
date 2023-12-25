//
//  UIView+Constraints.swift
//  DemoApp
//
//  Created by Mohammad Yasir Perwez on 25.12.23.
//

import UIKit

extension UIView {

    func pinToSuperview(insets: UIEdgeInsets = .zero) {
        guard let superview = superview else {
            return
        }
        pin(to: superview, insets: insets)
    }

    func pin(to view: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
        ])
    }
}
