//
//  SCUserData.swift
//  ScheduleCore
//
//  Created by Eric Liang on 6/30/19.
//  Copyright © 2019 Eric Liang. All rights reserved.
//

public struct SCUserData : Codable, Equatable {
    var currentUser = ""
    private var userData : [String: SCSchedule] = { ["": SCSchedule() ]
    }()
    public var currentSchedule : SCSchedule { return userData[currentUser]! }

    public init() {}
    public mutating func add(user : String, schedule : SCSchedule)
    {
        userData[user] = schedule
    }
}
