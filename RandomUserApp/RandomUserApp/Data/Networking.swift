//
//  Untitled.swift
//  RandomUserApp
//
//  Created by walid on 28/3/2025.
//

import Foundation

protocol Networking {
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
