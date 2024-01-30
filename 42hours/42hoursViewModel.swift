//
//  42hoursViewModel.swift
//  42hours
//
//  Created by Adrien Freire on 07/12/2023.
//

import SwiftUI
import CoreData

class Hours42ViewModel: ObservableObject {
    private var moc: NSManagedObjectContext

    @Published var periods: [Period]
    @Published var pressed: Bool = true
    @Published var timeSince:String =  ""
    init(context: NSManagedObjectContext, startPeriod: Date? = nil) {
        self.moc = context

        // FetchRequest initialisation
        let request: NSFetchRequest<Period> = Period.fetchRequest()
        request.sortDescriptors = []
        self.periods = (try? context.fetch(request)) ?? []
    }
    func refreshPressed() {
        if periods.last?.end == nil {
            pressed = false
        }
    }
    func getPressedState() -> Bool {
        return pressed
    }
    func setPressedState() {
        pressed.toggle()
    }
    func setStartPeriod() {
        let period = Period(context: moc)
        period.id = UUID()
        period.start = Date()
        period.end = nil
        try? moc.save()
        self.periods.append(period)
    }
    func getStartPeriod() {
        guard periods.last?.end == nil else {timeSince = ""; return}
        guard let mdr = periods.last?.start else {timeSince = "Error inteval"; return}
        let str = Date().timeIntervalSince(mdr)
//        guard let str = periods.last?.start!.timeIntervalSince(Date()) else {timeSince = ""; return}
        let hours = Int(str) / 3600
        let minutes = Int(str) % 3600 / 60
        timeSince = "\(hours) heures \(minutes) minutes since \(periods.last?.start?.formatted() ?? "Not defined")"
    }
    func setCurrentPeriod(end: Date){
        guard let period = periods.last else {return}
        period.end = end
        try? moc.save()
        self.periods.removeLast()
        self.periods.append(period)
    }
    func getPeriodStart(period: Period) -> String {
        return period.start?.formatted() ?? "Not defined"
    }
    func getPeriodEnd(period: Period) -> String {
        return period.end?.formatted() ?? "Not defined"
    }
    func getTimeThisMount() -> String {
        var total: TimeInterval = 0
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let currentMonth = calendar.component(.month, from: Date())
        let actualPeriods = periods.filter { period in
            let periodYear = calendar.component(.year, from: period.start!)
            let periodMonth = calendar.component(.month, from: period.start!)
            return currentYear == periodYear && currentMonth == periodMonth
        }
        for period in actualPeriods {
            if let startDate = period.start, let endDate = period.end {
                total += endDate.timeIntervalSince(startDate)
            }
        }
        let hours = Int(total) / 3600
        let minutes = Int(total) % 3600 / 60
        return "\(hours) heures \(minutes) minutes"
    }
}
