//
//  Untitled.swift
//  RandomUserApp
//
//  Created by walid on 1/4/2025.
//
import XCTest
@testable import RandomUserApp

class UserViewModelTests: XCTestCase {
    var viewModel: UserViewModel!
    var mockRepository: MockUserRepository!
    var mockUserDefaults: MockUserDefaultsManager!

    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        mockUserDefaults = MockUserDefaultsManager()
        viewModel = UserViewModel(repository: mockRepository, userDefaultsManager: mockUserDefaults)
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        mockUserDefaults = nil
        super.tearDown()
    }

    func testLoadUsers_Success() {
        let expectedUsers = [User(gender: "female", name: Name(title: "Ms", first: "Alice", last: "Johnson"),
                                  location: Location(street: Street(number: 123, name: "Main St"),
                                                      city: "New York", state: "NY", country: "USA",
                                                      postcode: .string("10001"),
                                                      coordinates: Coordinates(latitude: "40.7128", longitude: "-74.0060"),
                                                      timezone: Timezone(offset: "-4", description: "Eastern Time")),
                                  email: "alice.johnson@example.com", login: Login(uuid: "12345", username: "alice_j", password: "securePassword123"),
                                  dob: DateOfBirth(date: "1985-01-01", age: 36),
                                  registered: Registered(date: "2010-05-12", age: 11), phone: "123-456-7890", cell: "987-654-3210",
                                  id: ID(name: "SSN", value: "123-45-6789"), picture: Picture(large: "url", medium: "url", thumbnail: "url"), nat: "US")]
        mockRepository.mockUsers = expectedUsers
        mockRepository.shouldSucceed = true

        let expectation = self.expectation(description: "Load users successfully")

        viewModel.loadUsers { error in
            XCTAssertNil(error, "Should not return an error on success")
            XCTAssertEqual(self.viewModel.users.count, expectedUsers.count)
            XCTAssertEqual(self.viewModel.users.first?.name.first, "Alice")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testLoadUsers_Failure_With_Cache() {
        let cachedUsers = [User(gender: "female", name: Name(title: "Ms", first: "Charlie", last: "Johnson"),
                                location: Location(street: Street(number: 123, name: "Main St"),
                                                    city: "New York", state: "NY", country: "USA",
                                                    postcode: .string("10001"),
                                                    coordinates: Coordinates(latitude: "40.7128", longitude: "-74.0060"),
                                                    timezone: Timezone(offset: "-4", description: "Eastern Time")),
                                email: "alice.johnson@example.com", login: Login(uuid: "12345", username: "alice_j", password: "securePassword123"),
                                dob: DateOfBirth(date: "1985-01-01", age: 36),
                                registered: Registered(date: "2010-05-12", age: 11), phone: "123-456-7890", cell: "987-654-3210",
                                id: ID(name: "SSN", value: "123-45-6789"), picture: Picture(large: "url", medium: "url", thumbnail: "url"), nat: "US")]
        mockUserDefaults.save(cachedUsers, forKey: "cachedUsers")
        mockRepository.shouldSucceed = false
        mockRepository.mockError = .requestFailed

        let expectation = self.expectation(description: "Load users from cache on failure")

        viewModel.loadUsers { error in
            XCTAssertNotNil(error, "Should return an error")
            XCTAssertEqual(self.viewModel.users.count, cachedUsers.count)
            XCTAssertEqual(self.viewModel.users.first?.name.first, "Charlie")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testLoadUsers_Failure_Without_Cache() {
        mockRepository.shouldSucceed = false
        mockRepository.mockError = .requestFailed

        let expectation = self.expectation(description: "Load users fails without cache")

        viewModel.loadUsers { error in
            XCTAssertNotNil(error, "Should return an error")
            XCTAssertTrue(self.viewModel.users.isEmpty, "Users should be empty on failure with no cache")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
}
