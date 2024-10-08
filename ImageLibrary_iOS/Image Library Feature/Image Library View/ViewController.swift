//
//  ViewController.swift
//  ImageLibrary_iOS
//
//  Created by Vinod.Supnekar on 28/09/24.
//

import UIKit
import ImageLibrary

class ViewController: UIViewController {
  
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lableNoNetwork: UILabel!
    @IBOutlet weak var refreshView: UIButton!
    @IBOutlet weak var refreshViewParent: UIStackView!

    var viewModel: ImageCollectionViewModel?
    var tableCells: [EventCell] = []
    lazy private var store: ConcreteFeedStore? = {
        let storeUrl = controllerSpecificStoreURL()
        return try? ConcreteFeedStore(storeURL: storeUrl)
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Image Library"
        self.navigationItem.largeTitleDisplayMode = .always

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.isPrefetchingEnabled = true
        
        let url = "https://acharyaprashant.org/api/v2/content/misc/media-coverages"
        let loader = RemoteEventLoader(url: url, client: URLSesstionHTTPClient())
        self.viewModel = ImageCollectionViewModel(
            client: loader,
            delegate: self)
        self.viewModel?.fetchImages()
    }
    
    @IBAction func reloadView() {
        
        self.collectionView.isHidden = false
        self.refreshViewParent.isHidden = true
        self.viewModel?.fetchImages()
    }
    
    private func controllerSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("ImageModel.store")
    }
        
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.currentCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! EventCell
        
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none,
                           imageLoader: .none)
            } else {
                let cellModel = self.viewModel?.event(at: indexPath.row)
                if let model = cellModel {
                    
                    let imageURL =
                    "\(model.thumbnail.domain)/\(model.thumbnail.basePath)/0/\(model.thumbnail.key)"
                    let modelItem = EventCellViewModel(imageId: model.thumbnail.id, imageUrl: imageURL)
                    let client = URLSesstionHTTPClient()
                    let loader = RemoteImageLoader(url: imageURL, client: client)
                 
                    let genericStore = ConcreteImageLoader(concreteFeedStore: store,
                                                           remoteImageLoader: loader)
                    cell.configure(with: modelItem,
                                   imageLoader: genericStore)
                }
            }
        
        return cell
    }
}

extension ViewController: ImageCollectionDelegate {
    
    func onFetchCompleted(with data: [IndexPath]?) {
    
        guard let newIndexesToReload = data else {
            self.collectionView.isHidden = false
            self.collectionView.reloadData()
            return
        }
        
        let indexs = visibleIndexPathsToReload(intersecting: newIndexesToReload)
        collectionView.reloadItems(at: indexs)
    }
    
    func onFetchFailed(with error: Error) {
        
        self.collectionView.isHidden = true
        self.refreshViewParent.isHidden = false
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfCellsPerRow: CGFloat = 3
        let spacingBetweenCells: CGFloat = 5

        let totalSpacing = (numberOfCellsPerRow - 1) * spacingBetweenCells
        let availableWidth = collectionView.frame.width - totalSpacing - 10
        let cellWidth = availableWidth / numberOfCellsPerRow

        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}

private extension ViewController {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
      return indexPath.row >= viewModel?.currentCount ?? 0
  }

  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
      let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}


extension ViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        if  indexPaths.contains(where: isLoadingCell) {
            viewModel?.fetchImages()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let cell: EventCell? = cell as? EventCell
        cell?.cancelImageLoadingTask()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.alpha = 0.0
        UIView.animate(withDuration: 0.1) {
            cell.alpha = 1.0
        }
        let cell: EventCell? = cell as? EventCell
        cell?.fetchImage()
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
        indexPaths.forEach { indexPath in
            let cell = collectionView.cellForItem(at: indexPath) as! EventCell
            cell.cancelImageLoadingTask()
        }
    }

    
    
}
