//
//  FlutterMethodCallError.swift
//  gainsightpx
//
//  Created by Ramineni Sunanda on 27/08/20.
//

import Foundation

enum FlutterMethodCallError: Error {
    case invalidArguments
}

extension FlutterMethodCallError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidArguments:
            return NSLocalizedString("Something went wrong.", comment: "SDK Error")
        }
    }
}
