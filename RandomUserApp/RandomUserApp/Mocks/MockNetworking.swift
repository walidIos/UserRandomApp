//
//  Untitled.swift
//  RandomUserApp
//
//  Created by walid on 28/3/2025.
//
import Foundation

class MockNetworking: Networking {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completion(data, response, error)
        return URLSession.shared.dataTask(with: url)
    }
}
