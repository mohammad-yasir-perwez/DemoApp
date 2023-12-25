//
//  NSLayoutConstraint+priority.swift
//  DemoApp
//
//  Created by Mohammad Yasir Perwez on 25.12.23.
//

import UIKit

extension NSLayoutConstraint
{
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint
    {
        self.priority = priority
        return self
    }
}
