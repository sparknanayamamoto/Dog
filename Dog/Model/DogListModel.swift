//
//  DogListModel.swift
//  Dog
//
//  Created by spark-04 on 2024/02/16.
//

import Foundation
import UIKit


struct DogResponse: Codable {
    let message: [String: [String]]
}

enum DogEroor: Error {
    case invalidURL
    case networkError
    case decodeError
}


class Dog {
    
    func fetchDogBreeds() async -> Result<DogResponse, DogEroor> {
        guard let urlString = URL(string: "https://dog.ceo/api/breeds/list/all") else {
            return .failure(.invalidURL)
        }
        
        do {
            let (data,_) = try await URLSession.shared.data(from: urlString)
            let decoder = JSONDecoder()
            let dogJsonData = try decoder.decode(DogResponse.self, from: data)
            return .success(dogJsonData)
            
        } catch {
            return .failure(.decodeError)
        }
    }
    
}
