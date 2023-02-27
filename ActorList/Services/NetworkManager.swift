//
//  NetworkManager.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 08.06.2022.
//

import Foundation

enum URLs {
    static let characters = "https://www.breakingbadapi.com/api/characters/"
}

public enum Result {
    case success(Data)
    case failure
}

class NetworkManager {
    static func request(urlString: String, completion: @escaping (Result) -> ()) {
        guard let url = URL(string: urlString)  else {
            completion(.failure)
            return
        }
        
        #warning ("TODO: refactoring, use async/await")
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let responseData = data, error == nil else {
                completion(.failure)
                return
            }
            completion(.success(responseData))
        }
        task.resume()
    }
}
