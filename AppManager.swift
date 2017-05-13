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
    
    static var lunchKey: String = "lunch"
    static var lunchStartKey: String = "lunchTime"
    static var lunchTimeStringKey: String = "lunchTimeString"
    
    static var afternoonWorkingKey: String = "workingAfternoon"
    static var afternoonWorkingTimeKey: String = "workingAfternoonTime"
    static var afternoonWorkingTimeStringKey: String = "workingAfternoonTimeString"
    
    static var finishedDayKey: String = "finishedDay"
	
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
        defaults.set(workingTime(withKey: morningWorkingTimeKey), forKey: morningWorkingTimeStringKey)
        let now = Date()
        defaults.set(now, forKey: lunchStartKey)
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
        defaults.set(workingTime(withKey: lunchStartKey), forKey: lunchTimeStringKey)
        let now = Date()
        defaults.set(now, forKey: afternoonWorkingTimeKey)
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
        defaults.set(workingTime(withKey: afternoonWorkingTimeKey), forKey: afternoonWorkingTimeStringKey)
        defaults.set(true, forKey: finishedDayKey)
    }
    
    static func isDayFinished()->Bool {
		if let finished = defaults.object(forKey: finishedDayKey) as? Bool {
			return finished
		} else {
			return false
		}
    }
    
    static func reset() {
        let keys = [morningWorkingKey, morningWorkingTimeKey, morningWorkingTimeStringKey, lunchKey, lunchStartKey, lunchTimeStringKey, afternoonWorkingKey, afternoonWorkingTimeKey, afternoonWorkingTimeStringKey, finishedDayKey]
        
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
    
}
