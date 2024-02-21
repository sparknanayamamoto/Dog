//
//  DogPhotoViewController.swift
//  Dog
//
//  Created by spark-04 on 2024/02/19.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

struct DogImages: Codable {
    let message: [String]
}

class DogPhotoViewController: UIViewController, UICollectionViewDataSource {
    let dog = Dog()
    var selectedBreeds: String?
    var imageURLs: [URL] = []
    
    @IBOutlet weak var dogCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dogCollectionView.dataSource = self
        dogCollectionView.delegate = self
        
        Task {
            await fetchDogImage()
        }
        if let selectedBreeds = selectedBreeds {
            navigationItem.title = selectedBreeds
        }
    }
    
    
    func fetchDogImage() async {
        guard let selectedBreeds = selectedBreeds else {
            return
        }
        let apiUrl = "https://dog.ceo/api/breed/\(selectedBreeds)/images"
        
        do {
            let photoResponse = try await
            AF.request(apiUrl).serializingDecodable(DogImages.self).value
            
            imageURLs = photoResponse.message.compactMap{ URL(string: $0) }
            dogCollectionView.reloadData()
            print(photoResponse)
        } catch {
            print("Error fetching dog photos: \(error)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: imageURLs[indexPath.row])
        return cell
        
    }
}




extension DogPhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth: CGFloat = screenWidth / 2
        let cellHeight = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
