//
//  Utilities.swift
//  schedule
//
//  Created by Eric Liang on 10/20/19.
//  Copyright © 2019 Eric Liang. All rights reserved.
//

import Foundation
import SwiftUI
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}

extension Int {
    var asNumeric: String {
        switch self {
        case 1:
            return "1st"
        case 2:
            return "2nd"
        case 3:
            return "3rd"
        default:
            return String("\(self)th")
        }
    }
}
