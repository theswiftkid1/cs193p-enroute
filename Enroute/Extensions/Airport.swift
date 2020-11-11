//
//  Airport.swift
//  Enroute
//
//  Created by theswiftkid on 11/11/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import CoreData
import Combine

extension Airport {
    static func withICAO(_ icao: String, context: NSManagedObjectContext) -> Airport {
        let request = NSFetchRequest<Airport>(entityName: "Airport")
        request.predicate = NSPredicate(format: "icao_ = %@", icao)
        request.sortDescriptors = [NSSortDescriptor(key: "location", ascending: true)]
        let airports = (try? context.fetch(request)) ?? []
        if let airport = airports.first {
            return airport
        } else {
            let airport = Airport(context: context)
            airport.icao = icao
            AirportInfoRequest.fetch(icao) { airportInfo in
                self.update(from: airportInfo, context: context)
            }
            return airport
        }
    }

    static func update(from info: AirportInfo, context: NSManagedObjectContext) {
        if let icao = info.icao {
            let airport = self.withICAO(icao, context: context)
            airport.latitude = info.latitude
            airport.longitude = info.longitude
            airport.name = info.name
            airport.location = info.location
            airport.timezone = info.timezone
            airport.objectWillChange.send()
            airport.flightsTo.forEach { $0.objectWillChange.send() }
            airport.flightsFrom.forEach { $0.objectWillChange.send() }
            try? context.save()
        }
    }

    var flightsTo: Set<Flight> {
        get {
            (flightsTo_ as? Set<Flight>) ?? []
        }
        set {
            flightsTo_ = newValue as NSSet
        }
    }

    var flightsFrom: Set<Flight> {
        get {
            (flightsFrom_ as? Set<Flight>) ?? []
        }
        set {
            flightsFrom_ = newValue as NSSet
        }
    }
}

extension Airport: Identifiable, Comparable {
    var icao: String {
        get { icao_! } // TODO: protect with error in case of nil
        set { icao_ = newValue }
    }

    var friendlyName: String {
        let friendly = AirportInfo.friendlyName(name: self.name ?? "", location: self.location ?? "")
        return friendly.isEmpty ? icao : friendly
    }

    public var id: String { icao }

    public static func < (lhs: Airport, rhs: Airport) -> Bool {
        rhs.location ?? lhs.friendlyName < rhs.location ?? rhs.friendlyName
    }
}
