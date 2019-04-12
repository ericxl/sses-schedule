//
//  ScheduleData.swift
//  sses-schedule
//
//  Created by Eric Liang on 4/2/19.
//  Copyright © 2019 Eric Liang. All rights reserved.
//

import Foundation

class SSClass : Codable {
    private(set) var name : String
    var teacher : String
    var location : String

    init(_ name : String, teacher : String, location : String) {
        self.name = name
        self.teacher = teacher
        self.location = location
    }
    convenience init(_ name : String, teacher : String) {
        self.init(name, teacher: teacher, location:"")
    }
    convenience init(_ name : String) {
        self.init(name, teacher:"", location:"")
    }
    convenience init() {
        self.init("")
    }
}

typealias DayPeriod = String

class SSSchedule : Codable {
    var highSchool : Bool
    private var _data : [DayPeriod : SSClass]
    
    init(_ high : Bool) {
        self.highSchool = high
        _data = [DayPeriod : SSClass]()
        for letter in ["A", "B", "C", "D", "E", "F", "G"] {
            for index in 1...8
            {
                _data[letter + String(index)] = SSClass()
            }
        }
    }
    
    convenience init() {
        self.init(true)
    }
    
    private enum CodingKeys: String, CodingKey {
        case highSchool
        case _data
    }
    
    private static var highSchoolMap: [DayPeriodIdentifier : [DayPeriod]] = {
        return [
            DayPeriodIdentifier.DP0: ["B1", "C2", "D3", "E4", "F7", "G8"],
            DayPeriodIdentifier.DP1: ["A1", "B2", "C3", "D4", "E7", "F8"],
            DayPeriodIdentifier.DP2: ["A2", "B3", "C4", "D7", "E8", "G1"],
            DayPeriodIdentifier.DP3: ["A3", "B4", "C7", "D8", "F1", "G2"],
            DayPeriodIdentifier.DP4: ["A4", "B7", "C8", "E1", "F2", "G3"],
            DayPeriodIdentifier.DP5: ["A5", "B5", "C5", "D5", "E5", "F5", "G5"],
            DayPeriodIdentifier.DP6: ["A6", "B6", "C6", "D6", "E6", "F6", "G6"],
            DayPeriodIdentifier.DP7: ["A7", "B8", "D1", "E2", "F3", "G4"],
            DayPeriodIdentifier.DP8: ["A8", "C1", "D2", "E3", "F4", "G7"]
        ]
    }()
    
    private static var middleSchoolMap: [DayPeriodIdentifier : [DayPeriod]] = {
        return [
            DayPeriodIdentifier.DP0: ["B1", "C2", "D3", "E5", "F7", "G6"],
            DayPeriodIdentifier.DP1: ["A1", "B2", "C3", "D5", "E7", "F6"],
            DayPeriodIdentifier.DP2: ["A2", "B3", "C5", "D7", "E6", "G1"],
            DayPeriodIdentifier.DP3: ["A3", "B5", "C7", "D6", "F1", "G2"],
            DayPeriodIdentifier.DP4: ["A4", "B4", "C4", "D4", "E4", "F4", "G4"],
            DayPeriodIdentifier.DP5: ["A5", "B7", "C6", "E1", "F2", "G3"],
            DayPeriodIdentifier.DP6: ["A6", "C1", "D2", "E3", "F5", "G7"],
            DayPeriodIdentifier.DP7: ["A7", "B6", "D1", "E2", "F3", "G5"],
            DayPeriodIdentifier.DP8: ["A8", "B8", "C8", "D8", "E8", "F8", "G8"]
        ]
    }()
    
    private func dayPeriodIsValid(_ dayPeriod : DayPeriod) -> Bool {
        if dayPeriod.count != 2 {
            return false
        }
        let day = dayPeriod.first!
        if day < "A" || day > "G" {
            return false
        }
        if let period = Int(String(dayPeriod.last!)) {
            if period < 0 || period > 8 {
                return false
            }
        }
        return true
    }

    //MARK: Public Functions
    subscript(_ dayPeriod: DayPeriod) -> SSClass! {
        get {
            assert(dayPeriodIsValid(dayPeriod), "Day period invalid")
            return _data[dayPeriod]
        }
        set {
            assert(dayPeriodIsValid(dayPeriod), "Day period invalid")
            let map : [DayPeriodIdentifier : [String]] = self.highSchool ? SSSchedule.highSchoolMap : SSSchedule.middleSchoolMap
            var classID : DayPeriodIdentifier? = nil
            for (dayPeriodID, dayPeriods) in map {
                for dp in dayPeriods {
                    if dp == dayPeriod {
                        classID = dayPeriodID
                        break
                    }
                }
            }
            let targetDayPeriods = map[classID!]!
            for dp in targetDayPeriods {
                self[String(dp.first!), Int(String(dp.last!))!] = newValue
            }
        }
    }

    subscript(_ day: String, _ period: Int) -> SSClass! {
        get {
            let dayPeriodString = day + String(period)
            assert(dayPeriodIsValid(dayPeriodString), "Day period invalid")
            return _data[dayPeriodString]
        }
        set {
            let dayPeriodString = day + String(period)
            assert(dayPeriodIsValid(dayPeriodString), "Day period invalid")
            _data[dayPeriodString] = newValue
        }
    }
    
    private enum DayPeriodIdentifier {
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
}
