//
//  EventLoader.swift
//  ImageLibrary
//
//  Created by Vinod.Supnekar on 27/09/24.
//

import Foundation

public enum LoadEventResult {
    case success([EvetnItem])
    case error(Error)
}

public protocol EventLoader {
    func loadEvent(with page:Int, completion: @escaping (LoadEventResult)->Void)
}
