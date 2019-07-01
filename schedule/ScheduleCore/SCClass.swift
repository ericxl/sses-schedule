//
//  SCClass.swift
//  ScheduleCore
//
//  Created by Eric Liang on 6/30/19.
//  Copyright © 2019 Eric Liang. All rights reserved.
//

public struct SCClass : Codable, Equatable {
    public var name : String
    public var teacher : String?
    public var location : String?

    public init (name _name: String) {
        name = _name
    }
}
