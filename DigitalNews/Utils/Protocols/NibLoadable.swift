//
//  NibLoadable.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 03.10.2023.
//

import UIKit

protocol NibLoadable: AnyObject { }

extension NibLoadable where Self: UIView {
    static func instantiateFromNib() -> Self {
        UINib(nibName: "\(Self.self)", bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as! Self
    }
}
