//
//  TLLogerTestTests.swift
//  TLLogerTestTests
//
//  Created by tilltue on 2022/01/11.
//

import XCTest
@testable import TLLogger

final class TLLogerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLogDataSources() {
        // Arrange
        let sut = Log()
        
        // Act
        sut.log(.verbose, "verbose level log")
        sut.log(.debug, "debug level log")
        sut.log(.info, "info level log")
        sut.log(.warning, "warning level log")
        sut.log(.error, "error level log")
        
        // Assert
        XCTAssertEqual(sut.dataSources.count, 5)
        XCTAssertEqual(sut.dataSources,
                       [.init(.error, "error level log"),
                        .init(.warning, "warning level log"),
                        .init(.info, "info level log"),
                        .init(.debug, "debug level log"),
                        .init(.verbose, "verbose level log")
                       ])
    }
    
    func testFilteringLog_toLevel() {
        // Arrange
        let sut = Log()
        sut.log(.verbose, "verbose level log")
        sut.log(.debug, "debug level log")
        sut.log(.info, "info level log")
        sut.log(.warning, "warning level log")
        sut.log(.error, "error level log")
        
        // Act & Assert
        func parameterizedTests(level: Log.Level, expect: Log.LogData) {
            let dataSources = sut.filtered([level])
            XCTAssertEqual(dataSources.count, 1)
            XCTAssertEqual(dataSources.contains(expect), true)
        }
        
        parameterizedTests(level: .verbose, expect: .init(.verbose, "verbose level log"))
        parameterizedTests(level: .debug, expect: .init(.debug, "debug level log"))
        parameterizedTests(level: .info, expect: .init(.info, "info level log"))
        parameterizedTests(level: .warning, expect: .init(.warning, "warning level log"))
        parameterizedTests(level: .error, expect: .init(.error, "error level log"))
    }
    
    func testFilteringLog_toLevels() {
        // Arrange
        let sut = Log()
        sut.log(.verbose, "verbose level log")
        sut.log(.debug, "debug level log")
        sut.log(.info, "info level log")
        sut.log(.warning, "warning level log")
        sut.log(.error, "error level log")
        
        // Act
        let dataSources = sut.filtered([.verbose, .debug])
        
        // Assert
        XCTAssertEqual(dataSources.count, 2)
        XCTAssertEqual(dataSources,
                       [.init(.debug, "debug level log"),
                        .init(.verbose, "verbose level log")
                       ])
        
    }
    
    func testSearchLog() {
        // Arrange
        let sut = Log()
        sut.log(.verbose, "verbose level log 1")
        sut.log(.debug, "debug level log")
        sut.log(.info, "info level log")
        sut.log(.warning, "warning level log 1")
        sut.log(.error, "error level log")
        
        // Act & Assert
        func parameterizedTests(keyword: String, expect: [Log.LogData]) {
            let dataSources = sut.search(keyword)
            XCTAssertEqual(dataSources.count, expect.count)
            XCTAssertEqual(dataSources, expect)
        }
        
        parameterizedTests(keyword: "verbose", expect: [.init(.verbose, "verbose level log 1")])
        parameterizedTests(keyword: "1", expect: [.init(.warning, "warning level log 1"),
                                                  .init(.verbose, "verbose level log 1")])
        parameterizedTests(keyword: "VERBOSE", expect: [.init(.verbose, "verbose level log 1")])
    }
    
    func testGeneralLog() {
        // Arrange
        let sut = Log()
        sut.log(.verbose, "verbose level log 1")
        
        // Act
        let dataSources = sut.dataSources
        
        // Assert
        XCTAssertEqual(dataSources.count, 1)
        XCTAssertEqual(dataSources[0].category, .general)
    }
    
    func testNetworkLog() {
        let dummy = Log.NetworkDataResponse(request: nil, response: HTTPURLResponse(), metrics: nil, responseData: nil)
        let sut = Log()
        sut.log(.verbose, "verbose level log 1", dummy)
        
        // Act
        let dataSources = sut.dataSources
        
        // Assert
        XCTAssertEqual(dataSources.count, 1)
        XCTAssertEqual(dataSources[0].category, .network)
    }
}
