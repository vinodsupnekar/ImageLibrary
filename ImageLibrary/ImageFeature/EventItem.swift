//
//  EventItem.swift
//  ImageLibrary
//
//  Created by Vinod.Supnekar on 27/09/24.
//

import Foundation

public struct EvetnItem: Decodable {
    let thumbnail: ThumbnailItem
}

public struct ThumbnailItem: Decodable {
    let id: String
    let version: Double
    let domain: String
    let basePath: String
    let key: String
    let qualities: [Int]
    let aspectRatio: Double
}
