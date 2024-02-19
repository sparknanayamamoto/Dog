//
//  DogListModel.swift
//  Dog
//
//  Created by spark-04 on 2024/02/16.
//

import Foundation


class DogList {
    
    func fetchDogList() async -> Result<[], Error> {
        let urlString = "https://dog.ceo/api/breeds/list/all"
        guard let requestUrl = URL(string: urlString) else {
            // コードミスでしか通らない
            return
        }
        let dataTask = URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
            // 通信エラー
            if let error = error {
                print("Unexpected error: \(error.localizedDescription).")
                return
            }
            
            // HTTPレスポンスコードエラー
            if let response = response as? HTTPURLResponse {
                if !(200...299).contains(response.statusCode) {
                    print("Request Failed - Status Code: \(response .statusCode)")
                    return
                }
            }
        let date = Date().ISO8601Format()
        
    }
}
