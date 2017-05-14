//
//  AppManager.swift
//  MySiemensTracker
//
//  Created by Brennan Hoeting on 5/12/17.
//  Copyright © 2017 bustasari. All rights reserved.
//

import Foundation

class AppManager {
    static var morningWorkingKey: String = "workingMorning"
    static var morningWorkingTimeKey: String = "workingMorningTime"
    static var morningWorkingTimeStringKey: String = "morningWorkingTimeString"
    static var morningWorkingTimeDoubleKey: String = "morningWorkingTimeDouble"
    
    static var lunchKey: String = "lunch"
    static var lunchStartKey: String = "lunchTime"
    static var lunchTimeStringKey: String = "lunchTimeString"
    
    static var afternoonWorkingKey: String = "workingAfternoon"
    static var afternoonWorkingTimeKey: String = "workingAfternoonTime"
    static var afternoonWorkingTimeStringKey: String = "workingAfternoonTimeString"
    static var afternoonWorkingTimeDoubleKey: String = "workingAfternoonTimeDouble"
    
    static var finishedDayKey: String = "finishedDay"
    static var finishedDayTimeKey: String = "finishedDayTime"
    
    static var loggedDaysKey: String = "loggedDays"
	
	static var defaults = UserDefaults(suiteName: "group.bustusari.Tracker")!
    
    static func startWorking() {
        defaults.set(true, forKey: morningWorkingKey)
        let now = Date()
        defaults.set(now, forKey: morningWorkingTimeKey)
    }
    
    static func isWorkingMorning()->Bool {
        return defaults.bool(forKey: morningWorkingKey)
    }
    
    static func morningWorkingTimeString()->String {
        if let time = defaults.string(forKey: morningWorkingTimeStringKey) {
            return time
        } else if isWorkingMorning() {
            return workingTime(withKey: morningWorkingTimeKey)
        } else {
            return "00:00:00"
        }
    }
    
    static func startEating() {
        defaults.set(true, forKey: lunchKey)
        defaults.set(false, forKey: morningWorkingKey)
        let now = Date()
        defaults.set(now, forKey: lunchStartKey)
        defaults.set(workingRange(firstKey: morningWorkingTimeKey, secondKey: lunchStartKey), forKey: morningWorkingTimeStringKey)
        
        let workingTime = Double(now.minutes(from: date(withKey: morningWorkingTimeKey))) / 60.0
        defaults.set(workingTime, forKey: morningWorkingTimeDoubleKey)
    }
    
    static func isEating()->Bool {
        return defaults.bool(forKey: lunchKey)
    }
    
    static func eatingTimeString()->String {
        if let time = defaults.string(forKey: lunchTimeStringKey) {
            return time
        } else if isEating() {
            return workingTime(withKey: lunchStartKey)
        } else {
            return "00:00:00"
        }
    }
    
    static func finishEating() {
        defaults.set(false, forKey: lunchKey)
        defaults.set(true, forKey: afternoonWorkingKey)
        let now = Date()
        defaults.set(now, forKey: afternoonWorkingTimeKey)
        defaults.set(workingRange(firstKey: lunchStartKey, secondKey: afternoonWorkingTimeKey), forKey: lunchTimeStringKey)
    }
    
    static func isWorkingAfternoon()->Bool {
        return defaults.bool(forKey: afternoonWorkingKey)
    }
    
    static func workingAfternoonTimeString()->String {
        if let time  = defaults.string(forKey: afternoonWorkingTimeStringKey) {
            return time
        } else if isWorkingAfternoon() {
            return workingTime(withKey: afternoonWorkingTimeKey)
        } else {
            return "00:00:00"
        }
    }
    
    static func goHome() {
        defaults.set(false, forKey: afternoonWorkingKey)
        let now = Date()
        defaults.set(now, forKey: finishedDayTimeKey)
        defaults.set(workingRange(firstKey: afternoonWorkingTimeKey, secondKey: finishedDayTimeKey), forKey: afternoonWorkingTimeStringKey)
        defaults.set(true, forKey: finishedDayKey)
        let workingTime = Double(now.minutes(from: date(withKey: afternoonWorkingTimeKey))) / 60.0
        defaults.set(workingTime, forKey: afternoonWorkingTimeDoubleKey)
    }
    
    static func isDayFinished()->Bool {
		if let finished = defaults.object(forKey: finishedDayKey) as? Bool {
			return finished
		} else {
			return false
		}
    }
    
    static func reset() {
        let keys = [morningWorkingKey, morningWorkingTimeKey, morningWorkingTimeStringKey, lunchKey, lunchStartKey, lunchTimeStringKey, afternoonWorkingKey, afternoonWorkingTimeKey, afternoonWorkingTimeStringKey, finishedDayKey, finishedDayTimeKey]
        
        for key in keys {
            defaults.setValue(nil, forKey: key)
        }
    }
    
    static func workingTime(withKey startKey: String)->String {
        if let startTime = defaults.object(forKey: startKey) as? Date {
            
            let now = Date()
            
            let hoursSince = now.hours(from: startTime)
            var hoursSinceStr = String(hoursSince)
            let minutesSince = now.minutes(from: startTime) - (hoursSince * 60)
            var minutesSinceStr = String(minutesSince)
            let secondsSince = now.seconds(from: startTime) - (hoursSince * 60) - (minutesSince * 60)
            var secondsSinceStr = String(secondsSince)
            
            if hoursSince < 10 || hoursSince == 0 {
                hoursSinceStr = "0" + hoursSinceStr
            }
            if minutesSince < 10 || minutesSince == 0 {
                minutesSinceStr = "0" + minutesSinceStr
            }
            if secondsSince < 10 || secondsSince == 0 {
                secondsSinceStr = "0" + secondsSinceStr
            }
            
            return "\(hoursSinceStr):\(minutesSinceStr):\(secondsSinceStr)"
        } else {
            return "00:00:00"
        }
    }
    
    static func workingRange(firstKey: String, secondKey: String)->String {
        if let firstDate = defaults.object(forKey: firstKey) as? Date,
            let secondDate = defaults.object(forKey: secondKey) as? Date {
            
            let firstHour = Calendar.current.component(.hour, from: firstDate)
            let firstMinute = Calendar.current.component(.minute, from: firstDate)
            
            let secondHour = Calendar.current.component(.hour, from: secondDate)
            let secondMinute = Calendar.current.component(.minute, from: secondDate)
            
            return "\(firstHour):\(firstMinute)-\(secondHour):\(secondMinute)"
            
        } else {
            return "invalid key"
        }
    }
    
    static func date(withKey key: String)->Date {
        return defaults.object(forKey: key) as? Date ?? Date()
    }
    
    static func save() {
        addTodayKey()
    }
    
    static func addTodayKey() {
        let today = Date()
        let day = Calendar.current.component(.day, from: today)
        let month = Calendar.current.component(.month, from: today)
        let year = Calendar.current.component(.year, from: today)
        
        let todayKey = String(month) + "/" + String(day) + "/" + String(year)
        
        if var loggedKeys = defaults.array(forKey: loggedDaysKey) as? [String] {
            loggedKeys.append(todayKey)
            
            defaults.set(loggedKeys, forKey: loggedDaysKey)
        } else {
            defaults.set([todayKey], forKey: loggedDaysKey)
        }
    }
}
