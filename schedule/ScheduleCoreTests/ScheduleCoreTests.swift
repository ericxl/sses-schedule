//
//  ScheduleCoreTests.swift
//  ScheduleCoreTests
//
//  Created by Eric Liang on 6/30/19.
//  Copyright © 2019 Eric Liang. All rights reserved.
//

import XCTest
@testable import ScheduleCore

class ScheduleCoreTests: XCTestCase {

    func testEmptySchedule() {
        let sc = SCSchedule()
        for dp in SCDayPeriod.allCases {
            XCTAssertEqual(sc[dp], nil)
        }
    }

    func testPutSingleDays() {
        var schedule = SCSchedule()
        schedule.put(class: SCClass(name: "English"), dayPeriod: .A1)
        var history = SCClass(name: "History")
        history.location = "loc"
        history.teacher = "teacher"
        schedule.put(class: SCClass(name: "History"), dayPeriod: .A2)
        XCTAssertEqual(schedule[.A1]?.name, "English")
        XCTAssertEqual(schedule[.A1]?.teacher, "teacher")
        XCTAssertEqual(schedule[.A1]?.location, "loc")
        XCTAssertEqual(schedule[.A2]?.name, "History")
        XCTAssertEqual(schedule[.A2]?.teacher, nil)
        XCTAssertEqual(schedule[.A2]?.location, nil)
        XCTAssertEqual(schedule[.A3], nil)
        XCTAssertEqual(schedule[.B1], nil)
        XCTAssertEqual(schedule[.B2], nil)
        XCTAssertEqual(schedule[.B3], nil)
        XCTAssertEqual(schedule[.B4], nil)
        XCTAssertEqual(schedule[.B5], nil)
        XCTAssertEqual(schedule[.B6], nil)
        XCTAssertEqual(schedule[.B7], nil)
        XCTAssertEqual(schedule[.B8], nil)
    }

    func testGetClassesForDay() {
        var schedule = SCSchedule()
        schedule.put(class: SCClass(name: "English"), dayPeriod: .G1)
        schedule.put(class: SCClass(name: "History"), dayPeriod: .G2)
        schedule.put(class: SCClass(name: "Math"), dayPeriod: .G3)
        schedule.put(class: SCClass(name: "Music"), dayPeriod: .G4)
        XCTAssertEqual(schedule[.G].map( { $0?.name } ), ["English", "History", "Math", "Music", nil, nil, nil, nil])
    }

    func testPutReplaces() {
        var schedule = SCSchedule()
        schedule.put(class: SCClass(name: "English"), dayPeriod: .A1)
        schedule.put(class: SCClass(name: "History"), dayPeriod: .A1)
        XCTAssertEqual(schedule[.A1]?.name, "History")
        XCTAssertEqual(schedule[.A1]?.teacher, nil)
        XCTAssertEqual(schedule[.A1]?.location, nil)
    }

    func testPutMultiple() {
        var scheduleHigh = SCSchedule()
        let c = SCClass(name: "English")
        scheduleHigh.put(class: c, dayPeriod: .A1, all: true)
        XCTAssertEqual(scheduleHigh[.A1], c)
        XCTAssertEqual(scheduleHigh[.B2], c)
        XCTAssertEqual(scheduleHigh[.C3], c)
        XCTAssertEqual(scheduleHigh[.D4], c)
        XCTAssertEqual(scheduleHigh[.E7], c)
        XCTAssertEqual(scheduleHigh[.F8], c)
    }

    func testPutMultipleMiddleSchool() {
        let c1 = SCClass(name: "English")
        let c2 = SCClass(name: "History")

        var scheduleMiddle = SCSchedule()
        scheduleMiddle.degree = .middle
        scheduleMiddle.put(class: c1, dayPeriod: .A1, all: true)
        XCTAssertEqual(scheduleMiddle[.A1], c1)
        XCTAssertEqual(scheduleMiddle[.B2], c1)
        XCTAssertEqual(scheduleMiddle[.C3], c1)
        XCTAssertEqual(scheduleMiddle[.D5], c1)
        XCTAssertEqual(scheduleMiddle[.E7], c1)
        XCTAssertEqual(scheduleMiddle[.F6], c1)

        scheduleMiddle.put(class: c2, dayPeriod: .F4, all: true)
        XCTAssertEqual(scheduleMiddle[.A4], c2)
        XCTAssertEqual(scheduleMiddle[.B4], c2)
        XCTAssertEqual(scheduleMiddle[.C4], c2)
        XCTAssertEqual(scheduleMiddle[.D4], c2)
        XCTAssertEqual(scheduleMiddle[.E4], c2)
        XCTAssertEqual(scheduleMiddle[.F4], c2)
        XCTAssertEqual(scheduleMiddle[.G4], c2)
    }
}
