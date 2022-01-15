//
//  TLLogerTestTests.swift
//  TLLogerTestTests
//
//  Created by tilltue on 2022/01/11.
//

import XCTest
@testable import TLLogger

class TLLogerTests: XCTestCase {

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
}

extension Log.LogData: Equatable {
    public static func==(lhs: Self, rhs: Self) -> Bool {
        return lhs.level == rhs.level && lhs.message == rhs.message
    }
}
