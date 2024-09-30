//
//  ImageCell.swift
//  ImageLibrary
//
//  Created by Vinod.Supnekar on 29/09/24.
//

import UIKit
import ImageLibrary


class EventCell: UICollectionViewCell {
    
    @IBOutlet private var imageLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var indicatorView: UIActivityIndicatorView!
    private var cellMoel: EventCellViewModel?
    private var imageLoader: ImageLoader?
    private var imageLoadingTask: ImageDataLoaderTask?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indicatorView.startAnimating()
    }
    
    func configure(with cellMoel: EventCellViewModel?, imageLoader: ImageLoader?) {
        
        self.cellMoel = cellMoel
        self.imageLoader = imageLoader
        switch cellMoel {
        case .none:
            indicatorView.startAnimating()
        case .some(let model):
            imageLabel.text = model.imageUrl
            indicatorView.stopAnimating()
            imageLoadingTask = self.imageLoader?.loadImageData (
                with: model.imageId,
                from: model.imageUrl,
                completion: { [weak self] result in
                    self?.handle(result)
            })
        }
    }
    
    func handle(_ result: ImageLoader.Result) {
        switch result {
        case .success(let data):
            DispatchQueue.main.async {
                self.imageView.contentMode = .scaleAspectFit
                if data.count > 0 {
                    self.imageView.image = self.imageView.getCenterCropped(from: data)
                }
            }
            break
        case .failure:
            break
        }
    }
    
    func cancelImageLoadingTask() {
        
        imageLoadingTask?.cancel()
    }
}

private extension UIImageView {
    
    func getCenterCropped(from data: Data) -> UIImage {
        let img = UIImage(data: data)!
        let sideLength = min(
            self.frame.size.width,
            self.frame.size.height
        )
        
        let sourceSize = img.size
        let xOffset = (sourceSize.width ) / 2.0
        let yOffset = (sourceSize.height) / 2.0

        let cropRect = CGRect(
            x: xOffset,
            y: yOffset,
            width: sideLength,
            height: sideLength
        ).integral
        
        let sourceCGImage = img.cgImage!
        let croppedCGImage = sourceCGImage.cropping(
            to: cropRect
        )!
        return UIImage(cgImage: croppedCGImage)
    }
}
