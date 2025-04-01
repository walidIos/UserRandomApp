//
//  Untitled.swift
//  RandomUserApp
//
//  Created by walid on 28/3/2025.
//
import Foundation

extension URLSession: Networking {
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return dataTask(with: url, completionHandler: completion)
    }
}
