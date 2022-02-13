//
//  String+.swift
//  Reciplease
//
//  Created by fred on 07/02/2022.
//

import Foundation

extension String  {

    var isLetters: Bool {
        let notAllowed = CharacterSet(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", ";", "/", "@", "#"])
        return !isEmpty && rangeOfCharacter(from: notAllowed) == nil
    }
}

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
