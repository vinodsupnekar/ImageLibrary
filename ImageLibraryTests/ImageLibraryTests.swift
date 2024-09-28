//
//  ImageLibraryTests.swift
//  ImageLibraryTests
//
//  Created by Vinod.Supnekar on 27/09/24.
//

import Testing
import XCTest
@testable import ImageLibrary

class ImageLibraryTests: XCTestCase {

     func test_loadEvents_loads_firstPage() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        
        let url = "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100"
        let client = URLSesstionHTTPClient()
        let remoteEventLoader = RemoteEventLoader(url:url, client: client)
        
        let exp = self.expectation(description: "wait for session")
         remoteEventLoader.loadEvent(with: 1) { result in
             
             switch result {
             case .success(let events):
                 XCTAssertEqual(events.count, 10)
             case .error(let error):
                 XCTFail("failed with error \(error)")
             }
            
            exp.fulfill()
        }
         await fulfillment(of: [exp])
    }

}

