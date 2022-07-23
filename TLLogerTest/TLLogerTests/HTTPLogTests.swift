//
//  HTTPLogTests.swift
//  TLLogerTest
//
//  Created by tilltue on 2022/07/24.
//

import XCTest
@testable import TLLogger

class HTTPLogTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNetworkLog_moreInfo() {
        let dummy = Log.NetworkDataResponse.dummy
        let sut = Log()
        sut.log(.verbose, "verbose level log 1", dummy)
        
        // Act
        let dataSources = sut.dataSources
        
        // Assert
        XCTAssertEqual(dataSources.count, 1)
        XCTAssertEqual(dataSources[0].networkInfo?.api, "http://dummy.url")
        XCTAssertEqual(dataSources[0].networkInfo?.method, "GET")
        XCTAssertEqual(dataSources[0].networkInfo?.statusCode, 200)
        XCTAssertEqual(dataSources[0].networkInfo?.json, "{\n  \"log\" : \"dummy_json\"\n}")
        XCTAssertEqual(dataSources[0].networkInfo?.requestBody, "{\n  \"id\" : \"30\"\n}")
    }
}

private extension Log.NetworkDataResponse {
    static var dummy: Self {
        let url = URL(string: "http://dummy.url")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = Data("""
            { "id" : "30" }
        """.utf8)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let responseData = Data("""
            { "log" : "dummy_json" }
        """.utf8)
        return Log.NetworkDataResponse(request: request, response: response, metrics: nil, responseData: responseData)
    }
}
