//
//  LocalImageLoader.swift
//  ImageLibrary
//
//  Created by Vinod.Supnekar on 29/09/24.
//

public typealias RetrrieveCachedImageResult  = Result<(Data?), Error>

protocol FeedStore {
    
    typealias InsertionResult = Result<Void, Error>
    typealias InsertionCompletions = (InsertionResult) -> Void
    typealias RetrieveCompletions = (RetrrieveCachedImageResult) -> Void

    func insert(id:String, data: Data, completion: @escaping InsertionCompletions)
    func retrieve(with id: String, completion: @escaping RetrieveCompletions)
}
