//
//  Untitled.swift
//  RandomUserApp
//
//  Created by walid on 28/3/2025.
//
import Foundation

protocol NetworkManaging {
    associatedtype ResponseType: Decodable
    func request(url: URL, completion: @escaping (Result<ResponseType, NetworkError>) -> Void)
}
class NetworkManager<T: Decodable>: NetworkManaging {
    typealias ResponseType = T
    private let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func request(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        guard let url = URL(string: url.absoluteString) else {
            completion(.failure(.badURL))
            return
        }
        
        let task = networking.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(.requestFailed))
                print("Network error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknownError))
                return
            }
            
            if let networkError = self.handleStatusCode(httpResponse.statusCode) {
                completion(.failure(networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(.decodingError))
                print("Decoding error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}


extension NetworkManager {
    private func handleStatusCode(_ statusCode: Int) -> NetworkError? {
        switch statusCode {
        case 200:
            return nil
        case 400:
            return .badURL
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 500:
            return .internalServerError
        default:
            return .serverError(statusCode: statusCode)
        }
    }
}
