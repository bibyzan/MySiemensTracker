//
//  TrackerDay.swift
//  MySiemensTracker
//
//  Created by Brennan Hoeting on 5/14/17.
//  Copyright © 2017 bustasari. All rights reserved.
//

import Foundation

class TrackerDay {
    static var timeStatementKey: String = "timeStatement"
    static var workedHoursKey: String = "workedHours"
    
    var timeStatement: String
    var workedHours: Double
    
    init(_ timeStatement: String, _ workedHours: Double) {
        self.timeStatement = timeStatement
        self.workedHours = workedHours
    }
    
    init(key: String, defaults: UserDefaults) {
        self.timeStatement = defaults.string(forKey: key + TrackerDay.timeStatementKey) ?? ""
        self.workedHours = defaults.double(forKey: key + TrackerDay.workedHoursKey)
    }
    
    func saveToday(_ defaults: UserDefaults) {
        let today = Date()
        let day = Calendar.current.component(.day, from: today)
        let month = Calendar.current.component(.month, from: today)
        let year = Calendar.current.component(.year, from: today)
        
        let todayKey = String(month) + "/" + String(day) + "/" + String(year) + "-"
        
        defaults.set(self.timeStatement, forKey: todayKey + TrackerDay.timeStatementKey)
        defaults.set(self.workedHours, forKey: todayKey + TrackerDay.workedHoursKey)
    }
}
