//
//  DailyPlan.swift
//  Ctest
//
//  Created by 付敬格 on 16/7/31.
//  Copyright © 2016年 Hengyi Liu. All rights reserved.
//

import Foundation

class DailyPlan : NSObject, NSCoding{

// Insert code here to add functionality to your managed object subclass
    var date: NSNumber?
    var startChapter: NSNumber?
    var endChapter: NSNumber?
    var startBook: NSNumber?
    var endBook: NSNumber?
    var finish: NSNumber?
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeObject(startChapter, forKey: "startChapter")
        aCoder.encodeObject(endChapter, forKey: "endChapter")
        aCoder.encodeObject(startBook, forKey: "startBook")
        aCoder.encodeObject(endBook, forKey: "endBook")
        aCoder.encodeObject(finish, forKey: "finish")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        _ = aDecoder.decodeObjectForKey("date") as? NSNumber
        _ = aDecoder.decodeObjectForKey("startChapter") as? NSNumber
        _ = aDecoder.decodeObjectForKey("endChapter") as? NSNumber
        _ = aDecoder.decodeObjectForKey("startBook") as? NSNumber
        _ = aDecoder.decodeObjectForKey("endBook") as? NSNumber
        _ = aDecoder.decodeObjectForKey("finish") as? NSNumber
        
        self.init()
    }
}
