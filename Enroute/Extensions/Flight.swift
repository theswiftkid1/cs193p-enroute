//
//  Flight.swift
//  Enroute
//
//  Created by theswiftkid on 11/11/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import Foundation

extension Flight {
    var arrival: Date {
        get { arrival_ ?? Date(timeIntervalSinceReferenceDate: 0) }
        set { arrival_ = newValue }
    }

    var ident: String {
        get { ident_ ?? "Unknown" }
        set { ident_ = newValue }
    }

    var destination: Airport {
        get { destination_! } // TODO: protect against nil before shipping?
        set { destination_ = newValue }
    }

    var origin: Airport {
        get { origin_! } // TODO: maybe protect against when app ships?
        set { origin_ = newValue }
    }

    var airline: Airline {
        get { airline_! } // TODO: maybe protect against when app ships?
        set { airline_ = newValue }
    }

    var number: Int {
        Int(String(ident.drop(while: { !$0.isNumber }))) ?? 0
    }
}
