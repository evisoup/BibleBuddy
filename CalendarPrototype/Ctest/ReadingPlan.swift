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

class ReadingPlan : NSObject, NSCoding {
    
    var startDate: NSDate?
    var endDate: NSDate?
    var startBook: Int = 0
    var endBook: Int = 0
    
    var timeStamp: NSDate?
    var dailyPlans: [DailyPlan] = []

    static func DaysInBetween(Date1: NSDate, Date2: NSDate) -> Int
    {
        let cal = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = .Day
        let components = cal.components(unit, fromDate: Date1, toDate: Date2, options: [])
        return components.day+1 // We add one because the dates are inclusive
    }
    
    static func CreateReadingPlan(startFromBook: Int, endAtBook: Int, startDate: NSDate, endDate: NSDate) throws -> ReadingPlan {
        let thisPlan = ReadingPlan()
        thisPlan.startDate = startDate
        thisPlan.timeStamp = NSDate()
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
            return true
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(startDate, forKey: "startDate")
        aCoder.encodeObject(timeStamp, forKey: "timeStamp")
        aCoder.encodeObject(dailyPlans, forKey: "dailyPlans")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        _ = aDecoder.decodeObjectForKey("startDate") as? NSDate
        _ = aDecoder.decodeObjectForKey("timeStamp") as? NSDate
        _ = aDecoder.decodeObjectForKey("dailyPlans") as? [DailyPlan]
        
        self.init()
    }
    
    func SaveReadingPlan() {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(NSKeyedArchiver.archivedDataWithRootObject(self), forKey: "plan")
    }
    
    static func RestoreReadingPlan() -> ReadingPlan? {
        let ud = NSUserDefaults.standardUserDefaults()
        if let data = ud.objectForKey("plan") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            let readingPlan = unarc.decodeObjectForKey("root") as? ReadingPlan
            return readingPlan
        }
        return nil
    }

}
