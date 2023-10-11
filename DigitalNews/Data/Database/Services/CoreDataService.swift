//
//  CoreDataService.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 10.10.2023.
//

import Foundation
import CoreData

final class CoreDataService: CoreDataServiceProtocol {

    static let containerName = "DigitalNews"
    
    lazy private var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataService.containerName)
        container.loadPersistentStores { _, error in }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

        return container
    }()
    
    private var context: NSManagedObjectContext { container.viewContext }
    
    @discardableResult
    func create<T: NSManagedObject>(_ type: T.Type, _ handler: ((T) -> Void)?) -> T {
        let newObject = T(context: context)
        handler?(newObject)

        return newObject
    }
    
    func saveContext() {
        guard context.hasChanges else { return }
        try? context.save()
    }
    
    func write(_ handler: () -> Void) {
        handler()
        saveContext()
    }
    
    func fetch<T: NSManagedObject>(_ type: T.Type) -> [T] {
        (try? context.fetch(type.fetchRequest()) as? [T]) ?? []
    }
    
    func delete(_ object: NSManagedObject) {
        context.delete(object)
    }

}
