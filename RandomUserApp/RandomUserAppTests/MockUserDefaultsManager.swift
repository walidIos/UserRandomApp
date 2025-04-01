//
//  MockUserDefaultsManager.swift
//  RandomUserApp
//
//  Created by walid on 1/4/2025.
//
import XCTest
@testable import RandomUserApp

class MockUserDefaultsManager: UserDefaultsManaging {
    private var storage: [String: Any] = [:]

    func save<T: Encodable>(_ object: T, forKey key: String) {
        storage[key] = object
    }

    func load<T: Decodable>(forKey key: String) -> T? {
        return storage[key] as? T
    }
}
