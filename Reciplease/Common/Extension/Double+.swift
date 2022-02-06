//
//  Double+.swift
//  Reciplease
//
//  Created by fred on 06/02/2022.
//

import Foundation

extension Double {

    /// use to display formatted time
    func convertToString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = style
        return formatter.string(from: self) ?? ""
    }

    /// use to display yields
    func withoutDecimal() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.groupingSeparator = " "
        let number = NSNumber(value: self)
        guard let formattedValue = formatter.string(from: number) else { return "" }
        return formattedValue
    }
}
