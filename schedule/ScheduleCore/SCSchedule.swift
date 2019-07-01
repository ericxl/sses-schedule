//
//  SCSchedule.swift
//  ScheduleCore
//
//  Created by Eric Liang on 6/30/19.
//  Copyright © 2019 Eric Liang. All rights reserved.
//

public struct SCSchedule : Codable {
    public var username = ""
    public var degree = SCDegree.high
    var _data : [SCDayPeriod : SCClass?] = {
        var scheduleData = [SCDayPeriod : SCClass?]()
        for day in SCDay.allCases {
            for period in SCPeriod.allCases
            {
                scheduleData[SCDayPeriod(day: day, period: period)] = nil
            }
        }
        return scheduleData
    }()

    public init () {}

    public subscript(_ dayPeriod: SCDayPeriod) -> SCClass? {
        get {
            return _data[dayPeriod] ?? nil
        }
    }

    public subscript(_ day: SCDay) -> [SCClass?] {
        get {
            var classes = [SCClass?]()
            for period in SCPeriod.allCases {
                classes.append(self[SCDayPeriod(day: day, period: period)])
            }
            return classes
        }
    }

    public mutating func put(class _class: SCClass, dayPeriod: SCDayPeriod, all : Bool = false)
    {
        if !all {
            _data[dayPeriod] = _class
            return
        }
        enum DayPeriodIdentifier : CaseIterable {
            case DP0
            case DP1
            case DP2
            case DP3
            case DP4
            case DP5
            case DP6
            case DP7
            case DP8
        }
        let matching :(DayPeriodIdentifier) -> [SCDayPeriod] = degree == SCDegree.high ?
        {
            switch $0 {
            case .DP0:
            return [.B1, .C2, .D3, .E4, .F7, .G8]
            case .DP1:
            return [.A1, .B2, .C3, .D4, .E7, .F8]
            case .DP2:
            return [.A2, .B3, .C4, .D7, .E8, .G1]
            case .DP3:
            return [.A3, .B4, .C7, .D8, .F1, .G2]
            case .DP4:
            return [.A4, .B7, .C8, .E1, .F2, .G3]
            case .DP5:
            return [.A5, .B5, .C5, .D5, .E5, .F5, .G5]
            case .DP6:
            return [.A6, .B6, .C6, .D6, .E6, .F6, .G6]
            case .DP7:
            return [.A7, .B8, .D1, .E2, .F3, .G4]
            case .DP8:
            return [.A8, .C1, .D2, .E3, .F4, .G7]
            }
        } : {
            switch $0 {
            case .DP0:
                return [.B1, .C2, .D3, .E5, .F7, .G6]
            case .DP1:
                return [.A1, .B2, .C3, .D5, .E7, .F6]
            case .DP2:
                return [.A2, .B3, .C5, .D7, .E6, .G1]
            case .DP3:
                return [.A3, .B5, .C7, .D6, .F1, .G2]
            case .DP4:
                return [.A4, .B4, .C4, .D4, .E4, .F4, .G4]
            case .DP5:
                return [.A5, .B7, .C6, .E1, .F2, .G3]
            case .DP6:
                return [.A6, .C1, .D2, .E3, .F5, .G7]
            case .DP7:
                return [.A7, .B6, .D1, .E2, .F3, .G5]
            case .DP8:
                return [.A8, .B8, .C8, .D8, .E8, .F8, .G8]
            }
        }
        let matchingIdentifier : (SCDayPeriod) -> DayPeriodIdentifier = {
            for dpi in DayPeriodIdentifier.allCases {
                if matching(dpi).contains($0) {
                    return dpi
                }
            }
            return .DP5
        }

        for dp in matching(matchingIdentifier(dayPeriod)) {
            _data[dp] = _class
        }
    }
}
