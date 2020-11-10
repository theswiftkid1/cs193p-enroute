//
//  App.swift
//  Enroute
//
//  Created by theswiftkid on 11/10/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI

@main
struct EnrouteApp: App {
    var body: some Scene {
        WindowGroup {
            FlightsEnrouteView(flightSearch: FlightSearch(destination: "KSFO"))
        }
    }
}
