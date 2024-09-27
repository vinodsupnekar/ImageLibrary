//
//  EventItem.swift
//  ImageLibrary
//
//  Created by Vinod.Supnekar on 27/09/24.
//

import Foundation

struct EvetnItem {
    let thumbnail: ThumbnailItem
}

struct ThumbnailItem {
    let id: String
    let version: Int
    let domain: String
    let basePath: String
    let key: String
    let qualities: [Int]
    let aspectRatio: Int
}
