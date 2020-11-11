//
//  Airline.swift
//  Enroute
//
//  Created by theswiftkid on 11/11/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import Foundation

extension Airline: Identifiable, Comparable {
    var code: String {
        get { code_! } // TODO: maybe protect against when app ships?
        set { code_ = newValue }
    }
    var name: String {
        get { name_ ?? code }
        set { name_ = newValue }
    }
    var shortname: String {
        get { (shortname_ ?? "").isEmpty ? name : shortname_! }
        set { shortname_ = newValue }
    }
    var flights: Set<Flight> {
        get { (flights_ as? Set<Flight>) ?? [] }
        set { flights_ = newValue as NSSet }
    }
    var friendlyName: String { shortname.isEmpty ? name : shortname }

    public var id: String { code }

    public static func < (lhs: Airline, rhs: Airline) -> Bool {
        lhs.name < rhs.name
    }
}
