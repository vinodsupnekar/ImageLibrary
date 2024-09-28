//
//  ImageLoader.swift
//  ImageLibrary
//
//  Created by Vinod.Supnekar on 28/09/24.
//

import Foundation



class RemoteEventLoader: EventLoader {
    
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
    
    public func loadEvent(with page: Int, completion: @escaping (LoadEventResult) -> Void) {
        
        client.get(from: url, for: page) { [weak self] result in
            
            guard self != nil else {
                return
            }
            
            switch result {
            case .success((let data, let response)):
                completion(RemoteEventLoader.map(data,from: response))
            case .failure:
                completion(.error(Error.connectivity))
            }
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) -> LoadEventResult {
        
        do {
            let items = try EventsMapper.map(data, from: response)
            return .success(items)
        } catch {
            return .error(RemoteEventLoader.Error.invalidData)
        }
    }
}

final class EventsMapper {
    
    private struct Root: Decodable {
        let items: [EvetnItem]
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [EvetnItem] {

        guard response.statusCode == 200,
              let items = try? JSONDecoder().decode([EvetnItem].self, from: data) else {
            throw RemoteEventLoader.Error.connectivity
        }
        return items
    }
}
