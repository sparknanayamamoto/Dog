//
//  CollectionViewCell.swift
//  Dog
//
//  Created by spark-04 on 2024/02/19.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage


class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dogImage: UIImageView!
    
    func configure(with url: URL) {
        AF.request(url).responseImage { [weak self] response in
            switch response.result {
            case .success(let image):
                self?.dogImage.image = image
            case .failure(_):
                self?.dogImage.image = nil
            }
        }
    }
}
