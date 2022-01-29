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
    
    public func filtered(_ levels: [Level]) -> [LogData] {
        return logData.filter{ levels.contains($0.level) }
    }
    
    public func search(_ keyword: String) -> [LogData] {
        return logData.filter{
            $0.message.lowercased().contains(keyword.lowercased())
        }
    }
    
    public var dataSources: [LogData] {
        return logData
    }
}
