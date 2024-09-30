//
//  ImageCell.swift
//  ImageLibrary
//
//  Created by Vinod.Supnekar on 29/09/24.
//

import UIKit
import ImageLibrary


class EventCell: UICollectionViewCell {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var indicatorView: UIActivityIndicatorView!
    private var cellMoel: EventCellViewModel?
    private var imageLoader: ImageLoader?
    var imageLoadingTask: ImageDataLoaderTask?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indicatorView.startAnimating()
        self.imageView.image = UIImage(named: "no_image")
    }
    
    func configure(with cellMoel: EventCellViewModel?, imageLoader: ImageLoader?) {
        
        self.cellMoel = cellMoel
        self.imageLoader = imageLoader
        switch cellMoel {
        case .none:
            self.indicatorView.startAnimating()
            self.indicatorView.isHidden = false
        case .some(_):
            self.indicatorView.stopAnimating()
           break
        }
    }
    
    func fetchImage() {
        if let model = cellMoel {
            imageLoadingTask = self.imageLoader?.loadImageData (
                with: model.imageId,
                from: model.imageUrl,
                completion: { [weak self] result in
                    DispatchQueue.main.async {
                        self?.handle(result)
                        self?.indicatorView.stopAnimating()
                        self?.indicatorView.isHidden = true
                    }
                })
        }
    }
    
    func handle(_ result: ImageLoader.Result) {
        switch result {
        case .success(let data):
                self.imageView.contentMode = .scaleAspectFit
                if data.count > 0 {
                    self.imageView.image = self.imageView.getCenterCropped(from: data)
                }
            break
        case .failure:
            self.imageView.image = UIImage(named: "no_image")
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
