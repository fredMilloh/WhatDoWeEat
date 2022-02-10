//
//  TestCase.swift
//  RecipleaseTests
//
//  Created by fred on 08/02/2022.
//

import XCTest
@testable import Reciplease

class TestCase: XCTestCase {

    // MARK: - Data

    static func stubbedData( from json: String) -> Data? {
        let bundle = Bundle(for: TestCase.self)
        let url = bundle.url(forResource: json, withExtension: "json") ?? URL(fileURLWithPath: "www")
        return try? Data(contentsOf: url)
    }




}
