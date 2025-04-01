//
//  Untitled.swift
//  RandomUserApp
//
//  Created by walid on 28/3/2025.
//

import Foundation

protocol UserRepositoryProtocol {
    func fetchUsers(resultsCount: Int, completion: @escaping (Result<[User], NetworkError>) -> Void)

}

class UserRepository: UserRepositoryProtocol {
    private let networkManager: NetworkManager<UserResponse>
    private var resultsCount = 10
    
    init(networkManager: NetworkManager<UserResponse>) {
        self.networkManager = networkManager
    }

    func fetchUsers(resultsCount: Int, completion: @escaping (Result<[User], NetworkError>) -> Void) {
        let urlString = "https://randomuser.me/api/?results=\(resultsCount)"
              guard let url = URL(string: urlString) else {
                  completion(.failure(.badURL))
                  return
              }
        networkManager.request(url: url) { result in
                  switch result {
                  case .success(let response):
                      completion(.success(response.results))
                  case .failure(let error):
                      completion(.failure(error))
                  }
              }
    }
    
}
