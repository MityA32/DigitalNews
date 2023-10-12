//
//  DatabaseServiceable.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 10.10.2023.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {

    func create<T: NSManagedObject>(_ type: T.Type, _ handler: ((T) -> Void)?) -> T
    func saveContext()
    func write(_ handler: () -> Void)
    func fetch<T: NSManagedObject>(_ type: T.Type) -> [T]
    func remove(_ object: NSManagedObject)

}
