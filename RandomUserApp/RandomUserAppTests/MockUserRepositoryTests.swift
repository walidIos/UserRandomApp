//
//  UserRepositoryTests.swift
//  RandomUserApp
//
//  Created by walid on 1/4/2025.
//

import XCTest
@testable import RandomUserApp

class MockUserRepository: UserRepositoryProtocol {
    
    var shouldSucceed = true
        var mockUsers: [User] = []
        var mockError: NetworkError = .requestFailed

        func fetchUsers(resultsCount: Int, completion: @escaping (Result<[User], NetworkError>) -> Void) {
            if shouldSucceed {
                completion(.success(mockUsers))
            } else {
                completion(.failure(mockError))
            }
        }
}
