//
//  ImageCell.swift
//  ImageLibrary
//
//  Created by Vinod.Supnekar on 29/09/24.
//

import UIKit

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
    
    func configure(with cellMoel: EventCellViewModel?) {
        
        switch cellMoel {
        case .none:
            indicatorView.startAnimating()
        case .some(let moel):
            imageLabel.text = moel.imageName
            indicatorView.stopAnimating()
        }
    }
}
