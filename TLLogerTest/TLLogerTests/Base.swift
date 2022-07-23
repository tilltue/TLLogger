//
//  Base.swift
//  TLLogerTest
//
//  Created by tilltue on 2022/07/24.
//

import Foundation

@testable import TLLogger

extension Log.LogData: Equatable {
    public static func==(lhs: Self, rhs: Self) -> Bool {
        return lhs.level == rhs.level && lhs.message == rhs.message
    }
}
