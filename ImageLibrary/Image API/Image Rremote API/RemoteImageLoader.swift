//
//  RemoteImageLoader.swift
//  ImageLibrary
//
//  Created by Vinod.Supnekar on 29/09/24.
//

import Foundation

public class DataTask: ImageDataLoaderTask {
    
    private var dataTask: URLSessionDataTask?
    
    init(_ dataTask: URLSessionDataTask? = nil) {
        self.dataTask = dataTask
    }
    
    public func cancel() {
        dataTask?.cancel()
    }
}

public class RemoteImageLoader: ImageLoader {
    
    private let url: String
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: String, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func loadImageData(with id: String, from url: String, completion: @escaping (ImageLoader.Result) -> Void)  -> (any ImageDataLoaderTask)? {

        let task: URLSessionDataTask = client.get(from: url) { [weak self] result in
            
            guard self != nil else {
                return
            }
            
            switch result {
            case .success((let data, _)):
                completion(.success(data))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
        
        return DataTask( task)
    }
}
