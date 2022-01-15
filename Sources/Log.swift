//
//  Log.swift
//  TLLogger
//
//  Created by tilltue on 2021/02/23.
//

import Foundation

extension Log {
    public enum Level {
        case verbose
        case debug
        case info
        case warning
        case error
    }
    
    public struct LogData {
        public let level: Level
        public let message: String
        
        init(_ level: Level, _ message: String) {
            self.level = level
            self.message = message
        }
    }
}

public final class Log {
    
    private var logData: [LogData] = []
    
    public init() {
        
    }
    
    public func log(_ level: Level, _ message: String) {
        logData.insert(.init(level, message), at: 0)
    }
    
    public var dataSources: [LogData] {
        return logData
    }
}
