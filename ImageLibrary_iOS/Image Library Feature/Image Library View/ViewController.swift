//
//  ViewController.swift
//  ImageLibrary_iOS
//
//  Created by Vinod.Supnekar on 28/09/24.
//

import UIKit
import ImageLibrary

class EventCell: UICollectionViewCell {
    
    @IBOutlet private var imageLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var indicatorView: UIActivityIndicatorView!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indicatorView.startAnimating()
    }
    
    func configure(from cellMoel: EventCellViewModel) {
        imageLabel.text = cellMoel.imageName
        indicatorView.startAnimating()
    }
}

class ViewController: UIViewController {
  
    @IBOutlet weak var collectionView: UICollectionView!
    private var viewModel: ImageCollectionViewModel?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
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
        
        let cellModel = self.viewModel?.event(at: indexPath.row)
        if let model = cellModel {
            let imageURL =
            "\(model.thumbnail.domain)/\(model.thumbnail.basePath)/0/\(model.thumbnail.key)"
            
            let modelItem = EventCellViewModel(imageName: model.thumbnail.id, imageUrl: imageURL)
            cell.configure(from: modelItem)
        }
        return cell
    }
}

extension ViewController: ImageCollectionDelegate {
    
    func onFetchCompleted(with data: [IndexPath]?) {
        self.collectionView.reloadData()
    }
    
    func onFetchFailed(with error: any Error) {
        
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfCellsPerRow: CGFloat = 3
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
