//
//  Untitled.swift
//  RandomUserApp
//
//  Created by walid on 31/3/2025.
//

import Foundation

protocol UserDefaultsManaging {
    func save<T: Codable>(_ value: T, forKey key: String)
    func load<T: Codable>(forKey key: String) -> T?
}

class UserDefaultsManager: UserDefaultsManaging {
    
    func save<T: Codable>(_ value: T, forKey key: String) {
            let encoder = JSONEncoder()
            if let encodedData = try? encoder.encode(value) {
                UserDefaults.standard.set(encodedData, forKey: key)
            }
        }

        func load<T: Codable>(forKey key: String) -> T? {
            guard let savedData = UserDefaults.standard.data(forKey: key) else { return nil }
            let decoder = JSONDecoder()
            return try? decoder.decode(T.self, from: savedData)
        }
}
