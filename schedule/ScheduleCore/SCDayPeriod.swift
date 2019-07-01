//
//  SCDayPeriod.swift
//  ScheduleCore
//
//  Created by Eric Liang on 6/30/19.
//  Copyright © 2019 Eric Liang. All rights reserved.
//

public enum SCDayPeriod : String, Codable {
    case A1, A2, A3, A4, A5, A6, A7, A8
    case B1, B2, B3, B4, B5, B6, B7, B8
    case C1, C2, C3, C4, C5, C6, C7, C8
    case D1, D2, D3, D4, D5, D6, D7, D8
    case E1, E2, E3, E4, E5, E6, E7, E8
    case F1, F2, F3, F4, F5, F6, F7, F8
    case G1, G2, G3, G4, G5, G6, G7, G8

    public init(day: SCDay, period : SCPeriod)
    {
        self = SCDayPeriod(rawValue:day.rawValue + String(period.rawValue))!
    }
}

#if DEBUG
extension SCDayPeriod : CaseIterable {}
#endif
