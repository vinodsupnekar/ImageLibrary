//
//  ManagedImage.swift
//  ImageLibrary
//
//  Created by Vinod.Supnekar on 30/09/24.
//

import CoreData

@objc(ManagedImage)
public class ManagedImage: NSManagedObject {
    
    @NSManaged public var data: Data
    @NSManaged public var id : String
}

extension ManagedImage {
    
    static func find(in context: NSManagedObjectContext, with id: String) throws -> ManagedImage? {
        let request = NSFetchRequest<ManagedImage>(entityName: ManagedImage.entity().name!)
        request.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "id = %@", id)
        request.predicate = predicate
        return try context.fetch(request).first
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext, with id: String) throws -> ManagedImage {
        
        try find(in: context,with: id).map( context.delete)
        
        let image = ManagedImage(context: context)
        return image
    }
}
