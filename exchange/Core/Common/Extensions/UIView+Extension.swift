//
//  UIView+Extension.swift
//  exchange
//
//  Created by Nikolai on 14/02/2026.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
