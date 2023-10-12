//
//  UITableView+Extension.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 11.10.2023.
//

import UIKit

extension UITableView {
    func registerCell<T>(_ type: T.Type) {
        register(UINib(nibName: "\(T.self)", bundle: nil), forCellReuseIdentifier: "\(T.self)")
    }
}
