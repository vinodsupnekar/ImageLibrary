//
//  EventLoader.swift
//  ImageLibrary
//
//  Created by Vinod.Supnekar on 27/09/24.
//

import Foundation

enum LoadEventResult {
    case success([EvetnItem])
    case error(Error)
}

protocol EventLoader {
    func loadEvent(completion: @escaping (LoadEventResult)->Void)
}
