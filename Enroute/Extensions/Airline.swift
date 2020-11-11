//
//  Airline.swift
//  Enroute
//
//  Created by theswiftkid on 11/11/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import CoreData

extension Airline: Comparable {
    static func withCode(_ code: String, in context: NSManagedObjectContext) -> Airline {
        let request = fetchRequest(NSPredicate(format: "code_ = %@", code))
        let results = (try? context.fetch(request)) ?? []
        if let airline = results.first {
            return airline
        } else {
            let airline = Airline(context: context)
            airline.code = code
            AirlineInfoRequest.fetch(code) { info in
                let airline = self.withCode(code, in: context)
                airline.name = info.name
                airline.shortname = info.shortname
                airline.objectWillChange.send()
                airline.flights.forEach { $0.objectWillChange.send() }
                try? context.save()
            }
            return airline
        }
    }

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

    public static func < (lhs: Airline, rhs: Airline) -> Bool {
        lhs.name < rhs.name
    }

    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Airline> {
        let request = NSFetchRequest<Airline>(entityName: "Airline")
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        return request
    }
}
