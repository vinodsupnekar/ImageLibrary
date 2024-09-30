//
//  Untitled.swift
//  ImageLibrary
//
//  Created by Vinod.Supnekar on 30/09/24.
//

import CoreData

public class ConcreteFeedStore: FeedStore {
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bunle: Bundle = .main) throws {
        
        self.container = try NSPersistentContainer.load(modelName: "ImageModel", url: storeURL, in: bunle)
        self.context = container.newBackgroundContext()
    }
    
    func insert(id: String, data: Data, completion: @escaping InsertionCompletions) {
        
        do {
            let managedCache = try ManagedImage.newUniqueInstance(
                in: context, with: id)
            managedCache.id = id
            managedCache.data = data
            try context.save()
        } catch {
            completion(.failure(error))
        }
        completion(.success(()))
    }
    
    func retrieve(with id: String, completion: @escaping RetrieveCompletions) {
        let context = self.context
        context.perform {
            
            do {
             let managedCache = try ManagedImage.find(
                    in: context, with: id)
                completion(.success(managedCache?.data))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

extension NSPersistentContainer {
    
    enum LoadingError: Swift.Error {
        
        case modelNotFound
        case failedToLoadPersistentStore(Swift.Error)
    }
    
    static func load(modelName name: String, url: URL, in bundle: Bundle) throws -> NSPersistentContainer {
                
        let momdName = "ImageModel" //pass this as a parameter
        //...

        guard let modelURL = Bundle(for: ConcreteFeedStore.self).url(forResource: momdName, withExtension:"momd") else {
                fatalError("Error loading model from bundle")
        }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let descritption = NSPersistentStoreDescription(url: url)
        
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [descritption]
        
        var loadError: Swift.Error?
        container.loadPersistentStores { (_, error) in
            loadError = error
            }
        try loadError.map {
            throw LoadingError.failedToLoadPersistentStore($0)
        }
        return container
    }
}

extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}
