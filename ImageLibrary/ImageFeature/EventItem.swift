//
//  EventItem.swift
//  ImageLibrary
//
//  Created by Vinod.Supnekar on 27/09/24.
//

import Foundation

public struct EvetnItem: Decodable {
    public let thumbnail: ThumbnailItem
}

public struct ThumbnailItem: Decodable {
    public let id: String
    public let version: Double
    public let domain: String
    public let basePath: String
    public let key: String
    public let qualities: [Int]
    public let aspectRatio: Double
}
