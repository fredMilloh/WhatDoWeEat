//
//  OptionalString+.swift
//  Reciplease
//
//  Created by fred on 02/03/2022.
//

import Foundation

extension Optional where Wrapped == String {

    /// to replace ?? ""
    var orEmpty: String {
        switch self {
        case .none:
            return ""
        case .some(let wrapped):
            return wrapped
        }
    }
}
