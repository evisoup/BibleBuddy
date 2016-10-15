//
//  ReadingPlan.swift
//  Ctest
//
//  Created by 付敬格 on 16/7/31.
//  Copyright © 2016年 Hengyi Liu. All rights reserved.
//

import Foundation


enum CreatingReadingPlanError: ErrorType {
    case TotalReadingDaysNotPositive
}

class ReadingPlan : NSObject {
    
    var startDate: NSDate!
    var endDate: NSDate!
    var startBook: Int = 0
    var endBook: Int = 0
    
    var dailyPlans: [DailyPlan] = []
    
    // Singleton for the current plan
    static private var planInstance : ReadingPlan? = nil
    static var plan : ReadingPlan? {
        get {
            if planInstance == nil {
                planInstance = ReadingPlan.RestoreReadingPlan();
            }
            return planInstance
        }
        set {
            planInstance = newValue
        }
    }
    
    // This function unify hours
    static func ClearHour(date: NSDate) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        let timeStamp = dateFormatter.stringFromDate(date)
        let newTime = String(timeStamp.characters.dropLast(8)) + "00:00:00"
        return dateFormatter.dateFromString(newTime)!
    }

    static func DaysInBetween(Date1: NSDate, Date2: NSDate) -> Int
    {
        let cal = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = .Day
        let components = cal.components(unit, fromDate: ClearHour(Date1), toDate: ClearHour(Date2), options: [])
        return components.day+1 // We add one because the dates are inclusive
    }
    
    static func CreateReadingPlan(startFromBook: Int, endAtBook: Int, startDate: NSDate, endDate: NSDate) throws -> ReadingPlan {
        let thisPlan = ReadingPlan()
        thisPlan.startDate = ClearHour(startDate)
        thisPlan.endDate = ClearHour(endDate)
        thisPlan.startBook = startFromBook
        thisPlan.endBook = endAtBook
        
        var totalChapters = 0
        // Count the total number of chapters from beginBook to endBook
        for i in startFromBook...endAtBook {
            totalChapters += BibleIndex.BibleChapterNum[i]
        }
        
        // Compute the number of days between startDate and endDate
        let totalReadingDays = ReadingPlan.DaysInBetween(startDate, Date2: endDate)
        
        // We cannot have non-positive number of reading days
        if (totalReadingDays <= 0) {
            throw CreatingReadingPlanError.TotalReadingDaysNotPositive
        }
        
        // Compute each day's task
        let dailyChapters = totalChapters/totalReadingDays
        let reminderChapters = totalChapters%totalReadingDays
        
        // The first book that will be read for today
        var startBookForCurrentDate = 0
        // The first chapter that will be read for today
        var startChapterForCurrentDate = 1
        
        for currentDateFromStartDate in 0...totalReadingDays-1 {
            var chaptersForCurrentDate = dailyChapters;
            
            // We add the reminding chapters to the first a couple of days.
            if (currentDateFromStartDate < reminderChapters) {
                chaptersForCurrentDate += 1
            }
            
            var currentBook = startBookForCurrentDate;
            var startChapterForCurrentBook = startChapterForCurrentDate;
            while(chaptersForCurrentDate > 0) {
                // check how many chapters left in the current book
                let chapterLeftInCurrentBook = BibleIndex.BibleChapterNum[currentBook] - startChapterForCurrentBook + 1
                // Current book has more chapters than today's plan
                if (chapterLeftInCurrentBook >= chaptersForCurrentDate) {
                    let dailyPlan = DailyPlan()
                    dailyPlan.date = currentDateFromStartDate
                    dailyPlan.startChapter = startChapterForCurrentDate
                    dailyPlan.endChapter = startChapterForCurrentBook+chaptersForCurrentDate-1
                    dailyPlan.startBook = startBookForCurrentDate
                    dailyPlan.endBook = currentBook
                    thisPlan.dailyPlans.append(dailyPlan)
                    
                    startBookForCurrentDate = currentBook
                    startChapterForCurrentDate = startChapterForCurrentBook+chaptersForCurrentDate
                    chaptersForCurrentDate = 0
                } else {
                    chaptersForCurrentDate -= chapterLeftInCurrentBook
                    currentBook += 1
                    startChapterForCurrentBook = 1
                }
            }
        }
        return thisPlan
    }
    
    func todaysPlan(date: NSDate) -> DailyPlan? {
        let daysInBetween = ReadingPlan.DaysInBetween(startDate!, Date2: date)
        if daysInBetween <= 0 {
            return nil
        } else if (daysInBetween > dailyPlans.count) {
            return nil
        } else {
            return dailyPlans[daysInBetween-1]
        }
    }
    
    func isRead(date: NSDate) -> Bool {
        let daysInBetween = ReadingPlan.DaysInBetween(startDate!, Date2: date)
        if daysInBetween <= 0 {
            return false
        } else if (daysInBetween > dailyPlans.count) {
            return false
        } else if (dailyPlans[daysInBetween-1].finish) {
            return true
        } else {
            return false
        }
    }
    
    func isInPlan(date: NSDate) -> Bool {
        let daysInBetween = ReadingPlan.DaysInBetween(startDate!, Date2: date)
        if daysInBetween <= 0 {
            return false
        } else if (daysInBetween > dailyPlans.count) {
            return false
        } else {
            return true
        }
    }
    
    func checkIn(date: NSDate) -> Bool {
        let daysInBetween = ReadingPlan.DaysInBetween(startDate!, Date2: date)
        if daysInBetween <= 0 {
            return false
        } else if (daysInBetween > dailyPlans.count) {
            return false
        } else {
            dailyPlans[daysInBetween-1].finish = true
            self.SaveReadingPlan()
            return true
        }
    }
    
    private func toString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        let startDateInString = dateFormatter.stringFromDate(self.startDate)
        let endDateInString = dateFormatter.stringFromDate(self.endDate)
        var result = startDateInString + ";"
        result += endDateInString + ";"
        result += String(startBook) + ";"
        result += String(endBook) + ";"
        for dailyPlan in dailyPlans {
            if dailyPlan.finish {
                result += "T;"
            } else {
                result += "F;"
            }
        }
        
        return result
    }
    
    private static func toReadingPlan(planInString : String) -> ReadingPlan {
        let planArr = planInString.componentsSeparatedByString(";")
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        let plan = try! CreateReadingPlan(Int(planArr[2])!, endAtBook: Int(planArr[3])!, startDate: dateFormatter.dateFromString(planArr[0])!, endDate: dateFormatter.dateFromString(planArr[1])!)
        
        
        for i in 0...(plan.dailyPlans.count-1) {
            if planArr[i+4] == "T" {
                plan.dailyPlans[i].finish = true
            }
        }
        
        return plan
    }
    
    func SaveReadingPlan() {
        let stringForm = self.toString()
        NSUserDefaults.standardUserDefaults().setObject(stringForm, forKey: "plan")
        print("Save plan");
        ReadingPlan.plan = self
        
    }
    
    static func RestoreReadingPlan() -> ReadingPlan? {
        if let planInString = NSUserDefaults.standardUserDefaults().stringForKey("plan") {
            print("Restore plan successful")
            return toReadingPlan(planInString)
        }
        return nil
    }

}
