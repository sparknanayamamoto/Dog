//
//  DogDetailViewController.swift
//  Dog
//
//  Created by spark-04 on 2024/02/21.
//

import UIKit
import Alamofire
import AlamofireImage

class DogDetailViewController: UIViewController, UIScrollViewDelegate {
    var imageURLs: [URL] = []
    var selectedIndex = 0
    
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var dogImageView: UIImageView!
    
    let minZoomScale: CGFloat = 1.0
    let maxZoomScale: CGFloat = 4.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogImageView.contentMode = .scaleAspectFit
        if selectedIndex < imageURLs.count {
                    let selectedImageURL = imageURLs[selectedIndex]

                    // AlamofireImageを使用して画像を非同期で取得して表示
                    AF.request(selectedImageURL).responseImage { response in
                        if case .success(let image) = response.result {
                            self.dogImageView.image = image
                        }
                    }
                }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        adjustImageViewSize()
        updateContentInset()
    }
    
    func showImage(imageView: UIImageView, url: String) {
            let url = URL(string: url)
            do {
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)
                imageView.image = image
                
            } catch let err {
                print("Error: \(err.localizedDescription)")
            }
        }
    
    
    func setupScrollView() {
        imageScrollView.delegate = self
        imageScrollView.minimumZoomScale = minZoomScale
        imageScrollView.maximumZoomScale = maxZoomScale
        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.addSubview(dogImageView)
    }
    
    func adjustImageViewSize() {
        guard let size = dogImageView.image?.size, dogImageView.frame.isEmpty else { return }
        let wRate = imageScrollView.bounds.width / size.width
        let hRate = imageScrollView.bounds.height / size.height
        let rate = min(wRate, hRate, 1)
        dogImageView.frame.size = CGSize(width: size.width * rate, height: size.height * rate)
        // contentSize を画像サイズと同じにする
        imageScrollView.contentSize = dogImageView.frame.size
    }
    
    func updateContentInset() {
        imageScrollView.contentInset = UIEdgeInsets(
            top: max((imageScrollView.frame.height - dogImageView.frame.height) / 2, 0),
            left: max((imageScrollView.frame.width - dogImageView.frame.width) / 2, 0),
            bottom: 0,
            right: 0
        )
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return dogImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateContentInset()
    }
    
    
    
}


