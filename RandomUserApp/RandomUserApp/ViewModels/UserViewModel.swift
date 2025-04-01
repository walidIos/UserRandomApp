//
//  Untitled.swift
//  RandomUserApp
//
//  Created by walid on 28/3/2025.
//
import Foundation
import UIKit

class UserViewModel {
    var users: [User] = []
    private var repository: UserRepositoryProtocol
    private let userDefaultsManager: UserDefaultsManaging
    private var results: Int = 10
    private var isLoading = false
    init(repository: UserRepositoryProtocol, userDefaultsManager: UserDefaultsManaging) {
        self.repository = repository
        self.userDefaultsManager = userDefaultsManager
        
    }
    
    
    func loadUsers(completion: @escaping (String?) -> Void) {
        
        guard !isLoading else { return }
        isLoading = true
        repository.fetchUsers(resultsCount: results) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let users):
                self.users.append(contentsOf: users)
                self.results = 10
                self.userDefaultsManager.save(self.users, forKey: "cachedUsers")
                completion(nil)
            case .failure(let error):
                let errorMessage = self.getErrorMessage(error)
                if let cachedUsers: [User] = self.userDefaultsManager.load(forKey: "cachedUsers") {
                    self.users = cachedUsers
                    completion(errorMessage)
                }else {
                    completion(errorMessage)
                }
            }
        }
    }
    
    private func getErrorMessage(_ error: NetworkError) -> String {
        switch error {
        case .badURL:
            return NSLocalizedString("message_error_badUrl", comment: "")
        case .unauthorized:
            return NSLocalizedString("message_error_unauthorized", comment: "")
        case .forbidden:
            return NSLocalizedString("message_error_uforbidden", comment: "")
        case .notFound:
            return NSLocalizedString("message_error_notFound", comment: "")
        case .internalServerError:
            return NSLocalizedString("message_error_internalServerError", comment: "")
        case .serverError(let statusCode):
            return NSLocalizedString("message_error_serverError", comment: "")
        case .requestFailed:
            return NSLocalizedString("message_error_requestFailed", comment: "")
        case .decodingError:
            return NSLocalizedString("message_error_decodingError", comment: "")
        case .noData:
            return NSLocalizedString("message_error_noData", comment: "")
            
        case .unknownError:
            return NSLocalizedString("message_error_unknownError", comment: "")
        }
    }
    
}
