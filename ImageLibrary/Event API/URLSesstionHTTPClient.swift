//
//  Untitled.swift
//  ImageLibrary
//
//  Created by Vinod.Supnekar on 28/09/24.
//

import Foundation

public class URLSesstionHTTPClient: HTTPClient {

    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func get(from urlString: String,for page: Int = 0, completion: @escaping (HTTPClient.Result) -> Void) {
        
        let url = urlAppending(from: urlString, for: page)
        
        session.dataTask(with: URLRequest(url: url)) { data, httpResponse, error in
            
            if let error {
                return completion(.failure(error))
            } else if let data = data,
                      let response = httpResponse as? HTTPURLResponse {
                return completion(.success((data, response)))
            } else {
                return completion(.failure(NSError(domain: "", code: 0)))
            }
        }.resume()
    }
    
    func urlAppending(from urlString: String,for page: Int) -> URL {
        
        var urlComponents = URLComponents(string: urlString)!
        urlComponents.queryItems = [URLQueryItem(name: "limit", value: "\(page * 50)")]
        return urlComponents.url!
    }
    
    public func get(from urlString: String, completion: @escaping (HTTPClient.Result) -> Void) -> URLSessionDataTask {
            
        let url = URL(string: urlString)!
        let task = session.dataTask(with: URLRequest(url:  url)) { data, httpResponse, error in
            
            if let error {
                return completion(.failure(error))
            } else if let data = data,
                      let response = httpResponse as? HTTPURLResponse {
                return completion(.success((data, response)))
            } else {
                return completion(.failure(NSError(domain: "", code: 0)))
            }
        }
        task.resume()
        return task
    }
}
