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
    @Published var refresh: Bool = UserDefaults.standard.bool(forKey: "refresh")
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
        do {
            try moc.save() // Sauvegardez les changements dans le contexte.
        } catch {
            let nsError = error as NSError
            fatalError("Erreur non résolue \(nsError), \(nsError.userInfo)")
        }
        self.periods.removeLast()
        self.periods.append(period)
    }
    func getPeriodStart(period: Period) -> String {
        return period.start?.formatted() ?? "Not defined"
    }
    func getPeriodEnd(period: Period) -> String {
        return period.end?.formatted() ?? "Not defined"
    }
    func getTimePeriod(period: Period) -> String {
        guard period.end != nil else { return "Ongoing session" }
        let end = period.end ?? Date()
        let start = period.start ?? Date()
        let total: TimeInterval = end.timeIntervalSince(start)
        return "\(Int(total) / 3600) heures \(Int(total) % 3600 / 60) minutes"
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
    func getRefresh() -> Bool {return refresh}
    func setRefresh() {
        refresh.toggle()
        UserDefaults.standard.set(refresh, forKey: "refresh")
    }
    func changeTime(oldPeriod: Period, from: Date, to: Date) {
        oldPeriod.start = from
        oldPeriod.end = to
        do {
            try moc.save()
        } catch {
            let nsError = error as NSError
            fatalError("Erreur non résolue \(nsError), \(nsError.userInfo)")
        }
        if let index = periods.firstIndex(of: oldPeriod) {
            periods[index] = oldPeriod
        }
    }
    func deletePeriod(period:Period) {
        moc.delete(period)
        if let index = periods.firstIndex(of: period) {
            periods.remove(at: index)
        }
        do {
            try moc.save()
        } catch {
            let nsError = error as NSError
            fatalError("Erreur non résolue \(nsError), \(nsError.userInfo)")
        }
    }
}

extension Array where Element: Equatable {
    mutating func replaceAllOccurrences(of oldValue: Element, with newValue: Element) {
        for i in indices {
            if self[i] == oldValue {
                self[i] = newValue
            }
        }
    }
}
