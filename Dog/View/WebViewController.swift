//
//  WebViewController.swift
//  Dog
//
//  Created by spark-04 on 2024/02/22.
//

import UIKit
import WebKit
class WebViewController: UIViewController {
    let url = "https://spark-campus.saltworks.jp/"
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        if let url = URL(string: url) {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
