//
//  NibLoadable.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 03.10.2023.
//

import UIKit

extension UIViewController { 
    static func instantiateFromNib() -> Self {
        Self(nibName: "\(Self.self)", bundle: nil)
    }
}
