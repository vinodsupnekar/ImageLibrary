//
//  Untitled.swift
//  ImageLibrary
//
//  Created by Vinod.Supnekar on 28/09/24.
//

protocol HTTPClient {
    
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from urlString: String,for page: Int, completion: @escaping (Result) -> Void)
}
