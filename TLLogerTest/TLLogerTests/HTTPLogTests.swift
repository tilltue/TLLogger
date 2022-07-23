//
//  HTTPLogTests.swift
//  TLLogerTest
//
//  Created by tilltue on 2022/07/24.
//

import XCTest
import Alamofire

@testable import TLLogger

final class HTTPLogTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNetworkLog_moreInfo_withDummy() {
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
    
    func testNetworkLog_httpBin_method() {
        func parameterizedTest(method: String) {
            let expectation = self.expectation(description: "method tests")
            let sut = Log()
            let endpoint = "http://httpbin.org/\(method.lowercased())"
            let request = AF.request(endpoint, method: HTTPMethod(rawValue: method.uppercased()), parameters: nil, encoding: URLEncoding.default, headers: nil)
            request.responseDecodable { (dataResponse: DataResponse<HttpBinResult, AFError>) in
                guard let response = dataResponse.response else { return }
                sut.log(.verbose, "network log", .init(request: dataResponse.request, response: response, metrics: dataResponse.metrics, responseData: dataResponse.data))
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 1)
            
            // Act
            let dataSources = sut.dataSources
            
            // Assert
            XCTAssertEqual(dataSources.count, 1)
            XCTAssertEqual(dataSources[0].networkInfo?.api, endpoint)
            XCTAssertEqual(dataSources[0].networkInfo?.method, method.uppercased())
            XCTAssertEqual(dataSources[0].networkInfo?.statusCode, 200)
            XCTAssertNotNil(dataSources[0].networkInfo?.json)
            XCTAssertEqual(dataSources[0].networkInfo?.requestBody, nil)
        }
        parameterizedTest(method: "GET")
        parameterizedTest(method: "DELETE")
        parameterizedTest(method: "PUT")
        parameterizedTest(method: "POST")
    }
}

extension HTTPLogTests {
    struct HttpBinResult: Decodable {
        var data: String?
        var url: String?
        var json: String?
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
