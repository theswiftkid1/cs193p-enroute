//
//  EnrouteDataStore.swift
//  Enroute
//
//  Created by theswiftkid on 11/11/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import Foundation
import CoreData

class EnrouteDataStore {
    static let shared = EnrouteDataStore()

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EnrouteDataModel")

        container.loadPersistentStores { description, error in
            if let error = error {
                print(error)
            }
        }

        return container
    }()

    private init() {}

    public func saveContext() {
        let context = persistentContainer.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}
