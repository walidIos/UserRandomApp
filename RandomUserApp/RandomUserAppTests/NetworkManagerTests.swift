//
//  Untitled.swift
//  RandomUserApp
//
//  Created by walid on 28/3/2025.
//

import XCTest
@testable import RandomUserApp


class NetworkManagerTests: XCTestCase {
    var mockNetworking: MockNetworking!
    var networkManager: NetworkManager<UserResponse>!
    
    override func setUp() {
            super.setUp()
            
            mockNetworking = MockNetworking()
            networkManager = NetworkManager(networking: mockNetworking)
        }
        
        override func tearDown() {
            networkManager = nil
            mockNetworking = nil
            super.tearDown()
        }
    
    func testFetchData_Success() {
            let jsonData = """
            {
              "results": [
                {
                  "gender": "female",
                  "name": {
                    "title": "Miss",
                    "first": "Jennie",
                    "last": "Nichols"
                  },
                  "location": {
                    "street": {
                      "number": 8929,
                      "name": "Valwood Pkwy",
                    },
                    "city": "Billings",
                    "state": "Michigan",
                    "country": "United States",
                    "postcode": "63104",
                    "coordinates": {
                      "latitude": "-69.8246",
                      "longitude": "134.8719"
                    },
                    "timezone": {
                      "offset": "+9:30",
                      "description": "Adelaide, Darwin"
                    }
                  },
                  "email": "jennie.nichols@example.com",
                  "login": {
                    "uuid": "7a0eed16-9430-4d68-901f-c0d4c1c3bf00",
                    "username": "yellowpeacock117",
                    "password": "addison",
                    "salt": "sld1yGtd",
                    "md5": "ab54ac4c0be9480ae8fa5e9e2a5196a3",
                    "sha1": "edcf2ce613cbdea349133c52dc2f3b83168dc51b",
                    "sha256": "48df5229235ada28389b91e60a935e4f9b73eb4bdb855ef9258a1751f10bdc5d"
                  },
                  "dob": {
                    "date": "1992-03-08T15:13:16.688Z",
                    "age": 30
                  },
                  "registered": {
                    "date": "2007-07-09T05:51:59.390Z",
                    "age": 14
                  },
                  "phone": "(272) 790-0888",
                  "cell": "(489) 330-2385",
                  "id": {
                    "name": "SSN",
                    "value": "405-88-3636"
                  },
                  "picture": {
                    "large": "https://randomuser.me/api/portraits/men/75.jpg",
                    "medium": "https://randomuser.me/api/portraits/med/men/75.jpg",
                    "thumbnail": "https://randomuser.me/api/portraits/thumb/men/75.jpg"
                  },
                  "nat": "US"
                }
              ],
              "info": {
                "seed": "56d27f4a53bd5441",
                "results": 1,
                "page": 1,
                "version": "1.4"
              }
            }
            """.data(using: .utf8)
            
            mockNetworking.data = jsonData
            mockNetworking.error = nil
        let mockResponse = HTTPURLResponse(url: URL(string: "https://randomuser.me/api/?results=10")!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
        mockNetworking.response = mockResponse
            
            let url = URL(string: "https://randomuser.me/api/?results=10")!
            
            let expectation = self.expectation(description: "Fetch Data")
            
            networkManager.request(url: url) { result in
                switch result {
                case .success(let users):
                    XCTAssertEqual(users.results.count, 1)
                    XCTAssertEqual(users.results[0].name.first, "Jennie")
                    XCTAssertEqual(users.results[0].email, "jennie.nichols@example.com")
                case .failure(let error):
                    XCTFail("Expected success, but got failure: \(error)")
                }
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 1, handler: nil)
        }
        
    
    func testFetchData_Failure() {
        let mockData = """
            { "results": [] }
            """.data(using: .utf8)
        let mockResponse = HTTPURLResponse(url: URL(string: "https://randomuser.me/api/?results=10")!,
                                                statusCode: 404, // Simule une erreur 404 (not found)
                                                httpVersion: nil,
                                                headerFields: nil)
        mockNetworking.data = mockData
        mockNetworking.response = mockResponse
        let url = URL(string: "https://randomuser.me/api/?results=10")!
        let expectation = self.expectation(description: "Fetch Data")
        networkManager.request(url: url) { result in
            XCTAssertNotNil(result)
            switch result {
            case .success:
                XCTFail("Expected failure but got success.")
            case .failure(let error):
                if let networkError = error as? NetworkError {
                       XCTAssertEqual(networkError, .notFound)
                   } else {
                       XCTFail("Expected NetworkError.notFound but got \(error)")
                   }
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}
