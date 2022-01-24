//
//  Extensions.swift
//  MatchCards
//
//  Created by Shwetha Surendran on 21/01/22.
//

import UIKit


protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}


extension UICollectionViewCell: ReusableView {}

