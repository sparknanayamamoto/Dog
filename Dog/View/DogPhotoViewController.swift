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
    var images: [Image] = []
    
    @IBOutlet weak var dogCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dogCollectionView.dataSource = self
        dogCollectionView.delegate = self
        
        test()
        // Do any additional setup after loading the view.
    }
    
    func test () {
        Task {
            await fetchDogImage()
        }
    }
    
    func fetchDogImage() async -> Result<DogImages, DogEroor> {
        guard let selectedBreeds = selectedBreeds else {
            return .failure(.invalidURL)
        }
        guard let apiUrl = URL(string: "https://dog.ceo/api/breed/\(selectedBreeds)/images") else {
            return .failure(.invalidURL)
        }
        
        do {
            let (data,_) = try await URLSession.shared.data(from: apiUrl)
            let decoder = JSONDecoder()
            let dogJsonData = try decoder.decode(DogImages.self, from: data)
            print(dogJsonData)
            return .success(dogJsonData)
        
        } catch {
            return.failure(.decodeError)
        }
    }
    
    let imageView = UIImageView()
    func config(withURL: url) {
        AF.request(url.responceImage) { [weak self] response in
            switch responce.result {
            case .success(let image):
                self?.dogCollectionView.image = image
            case .failure(let error):
                self?.dogCollectionView.image = nil
                
            }
        }
    
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedBreeds?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath)
        let dogImage = [indexPath.row]
        guard let imageCell = cell as? CollectionViewCell else {
            return cell
        }
        
        }
    
            
            return imageCell
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
