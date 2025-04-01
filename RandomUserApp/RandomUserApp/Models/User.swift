//
//  Untitled.swift
//  RandomUserApp
//
//  Created by walid on 28/3/2025.
//

import Foundation


// MARK: - User
struct User: Codable {
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let login: Login
    let dob: DateOfBirth
    let registered: Registered
    let phone: String
    let cell: String
    let id: ID
    let picture: Picture
    let nat: String
}

// MARK: - Name
struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

// MARK: - Location
struct Location: Codable {
    let street: Street
    let city: String
    let state: String
    let country: String
    let postcode: Postcode
    let coordinates: Coordinates
    let timezone: Timezone
}

// MARK: - Street
struct Street: Codable {
    let number: Int
    let name: String
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude: String
    let longitude: String
}

// MARK: - Timezone
struct Timezone: Codable {
    let offset: String
    let description: String
}

// MARK: - Postcode (to handle both Int and String)
enum Postcode: Codable {
    case int(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(Postcode.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Postcode must be Int or String"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let intValue):
            try container.encode(intValue)
        case .string(let stringValue):
            try container.encode(stringValue)
        }
    }
}

// MARK: - Login
struct Login: Codable {
    let uuid: String
    let username: String
    let password: String
}

// MARK: - DateOfBirth
struct DateOfBirth: Codable {
    let date: String
    let age: Int
}

// MARK: - Registered
struct Registered: Codable {
    let date: String
    let age: Int
}

// MARK: - ID
struct ID: Codable {
    let name: String
    let value: String?
}

// MARK: - Picture
struct Picture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
}


extension User {
    var fullName: String {
        return "\(name.first) \(name.last)".trimmingCharacters(in: .whitespaces)
    }
}

extension User {
    var formattedAge: String {
        return "\(registered.age) ans"
    }
}

extension User {
    var formatedAdress : String {
        return  "\(location.street.number) \(location.street.name), \(location.city), \(location.country)"
    }
}
extension User {
    var formattedDate: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // Format d'entrée (format original)
        if let date = dateFormatter.date(from: dob.date) {
                dateFormatter.dateFormat = "dd/MM/yyyy" // Format de sortie (jj/mm/yyyy)
                return dateFormatter.string(from: date) // Retourner la date formatée en String
            }
            return dob.date
        }
}
