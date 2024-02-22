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
    var selectedIndex = 0
    
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail",
           let indexPath = dogCollectionView.indexPathsForSelectedItems?.first,
           let destinationVC = segue.destination as? DogDetailViewController {
            destinationVC.imageURLs = imageURLs
            destinationVC.selectedIndex = indexPath.row
            print(imageURLs)
        }
    }
    
}





extension DogPhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCell: CGFloat = 2
        let cellWidth = UIScreen.main.bounds.size.width / numberOfCell - 2
        dogCollectionView.contentMode = .scaleAspectFill
        return CGSize(width: cellWidth, height: cellWidth)
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
