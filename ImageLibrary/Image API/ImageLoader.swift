//
//  ImageLoader.swift
//  ImageLibrary
//
//  Created by Vinod.Supnekar on 29/09/24.
//

public protocol ImageDataLoaderTask {
    
    func cancel()
}

public protocol ImageLoader {
    
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(with id: String, from url: String, completion: @escaping (Result) -> Void) -> ImageDataLoaderTask

}

