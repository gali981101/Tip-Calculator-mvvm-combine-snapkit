//
//  UIResponder+Extension.swift
//  tip-calculator
//
//  Created by Terry Jason on 2024/3/8.
//

import UIKit

extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
