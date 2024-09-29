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
    var viewModel: ImageCollectionViewModel?
    var tableCells: [EventCell] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        
        let url = "https://acharyaprashant.org/api/v2/content/misc/media-coverages"
        let loader = RemoteEventLoader(url: url, client: URLSesstionHTTPClient())
        self.viewModel = ImageCollectionViewModel(
            client: loader,
            delegate: self)
        self.viewModel?.fetchImages()
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
                    cell.configure(with: modelItem,
                                   imageLoader: loader)
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
    
    func onFetchFailed(with error: any Error) {
        
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfCellsPerRow: CGFloat = 2
        let spacingBetweenCells: CGFloat = 3

        let totalSpacing = (numberOfCellsPerRow - 1) * spacingBetweenCells
        let availableWidth = collectionView.frame.width - totalSpacing
        let cellWidth = availableWidth / numberOfCellsPerRow

        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
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
        
//        let cell = collectionView.cellForItem(at: indexPath) as! EventCell
//        cell.cancelImageLoadingTask()
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
        indexPaths.forEach { indexPath in
            let cell = collectionView.cellForItem(at: indexPath) as! EventCell
            cell.cancelImageLoadingTask()
        }
    }

    
    
}
