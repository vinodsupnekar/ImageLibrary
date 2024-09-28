//
//  ImageCollectionViewModel.swift
//  ImageLibrary
//
//  Created by Vinod.Supnekar on 28/09/24.
//
import ImageLibrary

protocol ImageCollectionDelegate: AnyObject {
    
    func onFetchCompleted(with data: [IndexPath])
    func onFetchFailed(with error: Error)
}

class ImageCollectionViewModel {
    
    private let client: EventLoader
    private weak var delegate: ImageCollectionDelegate?
    private var events: [EvetnItem] = []
    var currentPage:Int = 1
    private var total = 100
    
    init(client: EventLoader, delegate: ImageCollectionDelegate) {
        self.client = client
        self.delegate = delegate
    }
    
    func fetchImages() {
        
        client.loadEvent(with: currentPage) { [weak self] result in
            
            guard let self else {
                return
            }
            DispatchQueue.main.async {
                
            switch result {
            case .success(let result):
                let previousResult = self.events
                self.events.append(contentsOf: result)
                
                if  self.currentPage > 1 {
                    let indexPathsToReload = self.calculateIndexPathsToReload(from: previousResult)
                    self.delegate?.onFetchCompleted(with: indexPathsToReload)
                }
                self.currentPage += 1
            case .error(let error):
                    self.delegate?.onFetchFailed(with: error)
            @unknown default:
                break
            }
        }
        }
    }
    
    private func calculateIndexPathsToReload(from previousResult: [EvetnItem]) -> [IndexPath] {
     let secondHalf = events[previousResult.count...]
      let startIndex = events.count - secondHalf.count
      let endIndex = events.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }

}
