
//
//  ConcreteImageLoader.swift
//  ImageLibrary
//
//  Created by Vinod.Supnekar on 30/09/24.
//

protocol ConcreteImageLoaderTask: ImageDataLoaderTask {

}

public class ConcreteImageLoader: ImageLoader {
   
    private let concreteFeedStore: ConcreteFeedStore?
    private let remoteImageLoader: RemoteImageLoader
    
    public init(concreteFeedStore: ConcreteFeedStore?, remoteImageLoader: RemoteImageLoader) {
        self.concreteFeedStore = concreteFeedStore
        self.remoteImageLoader = remoteImageLoader
    }
    
    public func loadImageData(with id: String, from url: String, completion: @escaping (Result<Data, any Error>) -> Void) -> (any ImageDataLoaderTask)? {
        
        var task: ImageDataLoaderTask? = nil
        
        if let store = concreteFeedStore {
            store.retrieve(with: id) { result in
                
                switch result {
                case .success(let data):
                    if let data = data {
                        completion(.success(data))
                    } else {
                        task = self.fetchRemoteImages(with: id, from: url, completion: completion)
                    }
                case .failure(_):
                    task = self.fetchRemoteImages(with: id, from: url, completion: completion)
                }
            }
        } else {
            task = self.fetchRemoteImages(with: id, from: url, completion: completion)
        }
        return task
    }
    
    func fetchRemoteImages(with id: String, from url: String, completion: @escaping (Result<Data, any Error>) -> Void) -> (any ImageDataLoaderTask)? {
        
        let task = self.remoteImageLoader.loadImageData(
            with: id, from: url) { result in
                
                switch result {
                case .success(let data):
                    completion(.success(data))
                    // Insert this to Coredata storage
                    self.concreteFeedStore?.insert(id: id, data: data, completion: { result in
                        switch result {
                        case .success(_):
                            print("save success \(id)")
                        case .failure(_):
                            print("save failure")
                        }
                    })
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        return task
    }
}
