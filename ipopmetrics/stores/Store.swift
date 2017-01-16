//
//  Store.swift
//  Popmetrics
//
//  Created by Rares Pop
//  Copyright © 2016 Popmetrics. All rights reserved.
//

import Foundation
import CoreData

class Store {
    
    internal let context: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    internal func readJsonFile(_ fileName: String) -> [String: Any]? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                
                return json as? [String : AnyObject]
            } catch let err as NSError {
                print(err.localizedDescription)
            }
        }
        return nil
    }
    
    internal func createEntityWithName(_ name: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: name, into: context)
    }
    
    internal func createFetchRequest<T: NSManagedObject>(entityName: String? = nil) -> NSFetchRequest<T>? {
        if #available(iOS 10.0, *) {
            return T.fetchRequest() as? NSFetchRequest<T>
        } else if let entityName = entityName {
            return NSFetchRequest(entityName: entityName)
        }
        return nil
    }
    
    internal func executeFetchRequest<T: NSManagedObject>(fetchRequest: NSFetchRequest<T>) -> Array<T>? {
        do {
            return try context.fetch(fetchRequest)
        } catch let error as NSError {
            // TODO Log error
            print("\(error)")
        }
        return nil
    }
    
    func saveState() {
        do {
            try context.save()
        } catch let error as NSError {
            // TODO Log error
            print("\(error)")
        }
    }
    
    
}
