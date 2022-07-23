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
    
    public enum Category {
        case general
        case network
    }
    
    public struct LogData {
        public let level: Level
        public let message: String
        public let category: Category
        public let networkInfo: NetworkInfo?
        
        internal init(_ level: Level, _ message: String, _ category: Category, dataResponse: NetworkDataResponse?) {
            self.level = level
            self.message = message
            self.category = category
            self.networkInfo = try? NetworkInfo(dataResponse: dataResponse)
        }
        
        internal init(_ level: Level, _ message: String, _ category: Category) {
            self.init(level, message, category, dataResponse: nil)
        }
        
        internal init(_ level: Level, _ message: String) {
            self.init(level, message, .general)
        }
    }
    
    public struct NetworkDataResponse {
        public var request: URLRequest?
        public var response: HTTPURLResponse
        public var metrics: URLSessionTaskMetrics?
        public var responseData: Data?
        
        public init(request: URLRequest? = nil,
                    response: HTTPURLResponse,
                    metrics: URLSessionTaskMetrics? = nil,
                    responseData: Data? = nil)
        {
            self.request = request
            self.response = response
            self.metrics = metrics
            self.responseData = responseData
        }
    }
    
    public struct NetworkInfo {
        let api: String
        let statusCode: Int
        let duration: TimeInterval?
        let json: String?
        let method: String?
        let requestBody: String?
        
        internal init(dataResponse: NetworkDataResponse?) throws {
            let response = try dataResponse.unwrap()
            self.api = try response.response.url.unwrap().absoluteString
            self.method = response.request?.httpMethod
            self.statusCode = response.response.statusCode
            self.duration = response.metrics?.taskInterval.duration
            self.requestBody = response.request?.httpBody?.toJson()
            self.json = response.responseData?.toJson()
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
    
    public func log(_ level: Level, _ message: String, _ dataResponse: NetworkDataResponse) {
        logData.insert(.init(level, message, .network, dataResponse: dataResponse), at: 0)
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

private struct NilError: Error {}

private extension Optional {
    func unwrap(or error: @autoclosure () -> Error = NilError()) throws -> Wrapped {
        switch self {
        case .some(let w): return w
        case .none: throw error()
        }
    }
}

private extension Data {
    func toJson() -> String? {
        guard
            let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let pretty = String(data: data, encoding: .utf8)
        else {
            return nil
        }
        return pretty
    }
}
