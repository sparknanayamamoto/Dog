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
    let minZoomScale: CGFloat = 1.0
    let maxZoomScale: CGFloat = 5.0
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var dogImageView: UIImageView!
    
    @objc private func scrollViewDoubleTapped(_ gesture: UITapGestureRecognizer) {
        guard let scrollView = gesture.view as? UIScrollView else { return }
        if scrollView.zoomScale == minZoomScale {
            // タップされた場所を中心に最大に拡大する
            let location = gesture.location(in: scrollView)
            let rect = zoomRect(for: scrollView, scale: maxZoomScale, center: location)
            scrollView.zoom(to: rect, animated: true)
        } else {
            // 最小に戻す
            scrollView.setZoomScale(minZoomScale, animated: true)
        }
    }
    
    private func zoomRect(for scrollView: UIScrollView, scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.width = scrollView.frame.size.width / scale
        zoomRect.size.height = scrollView.frame.size.height / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIScrollViewの設定
        imageScrollView.minimumZoomScale = minZoomScale
        imageScrollView.maximumZoomScale = maxZoomScale
        imageScrollView.delegate = self
        
        // UIImageViewの設定
        if selectedIndex < imageURLs.count {
            let selectedImageURL = imageURLs[selectedIndex]
            // AlamofireImageを使用して画像を非同期で取得して表示
            AF.request(selectedImageURL).responseImage { response in
                if case .success(let image) = response.result {
                    self.dogImageView.image = image
                    self.dogImageView.contentMode = .scaleAspectFit
                    self.imageScrollView.contentSize = image.size
                }
            }
        }
        
        // ダブルタップジェスチャーの設定
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewDoubleTapped(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        imageScrollView.addGestureRecognizer(doubleTapGesture)
    }
    
    // UIScrollViewDelegateメソッド: 拡大・縮小するために必要
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return dogImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateContentInset()
    }
    
    func updateContentInset() {
        let imageSize = dogImageView.frame.size
        let boundsSize = imageScrollView.bounds.size
        var contentInset = UIEdgeInsets.zero
        
        if imageSize.width < boundsSize.width {
            contentInset.left = (boundsSize.width - imageSize.width) / 2
            contentInset.right = contentInset.left
        }
        
        if imageSize.height < boundsSize.height {
            contentInset.top = (boundsSize.height - imageSize.height) / 2
            contentInset.bottom = contentInset.top
        }
        
        imageScrollView.contentInset = contentInset
    }
}



