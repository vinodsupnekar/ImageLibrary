//
//  ImageLibrary_iOSTests.swift
//  ImageLibrary_iOSTests
//
//  Created by Vinod.Supnekar on 28/09/24.
//

import XCTest
@testable import ImageLibrary_iOS
@testable import ImageLibrary

class ImageLibrary_iOSTests: XCTestCase {

     func testModelIntegration_loadsNextPageOnSecondRequest() {

        // Given
        let url = "https://acharyaprashant.org/api/v2/content/misc/media-coverages"
        let client = URLSesstionHTTPClient()
        let remoteEventLoader = RemoteEventLoader(url: url, client: client)
        let expectation = expectation(description: "wait for completion")
         let mockDelegate = MockEventsDelegate(exp: expectation)
         let model = ImageCollectionViewModel(client: remoteEventLoader, delegate: mockDelegate)

        //When
        model.fetchImages()
        model.fetchImages()
         
         wait(for: [expectation], timeout: 2.0)
        //Then
         XCTAssertEqual(mockDelegate.indexToUpdate.count, 10)
         XCTAssertEqual(model.currentPage, 3)
    }
    
    class MockEventsDelegate: ImageCollectionDelegate {
        
        var indexToUpdate:[IndexPath] = []
        
        private let exp: XCTestExpectation!
        
        init( exp: XCTestExpectation!) {
            self.exp = exp
        }
        
        func onFetchCompleted(with data: [IndexPath]) {
            indexToUpdate.append(contentsOf: data)
            exp.fulfill()
        }
        
        func onFetchFailed(with error: any Error) {
            
        }

    }

}
