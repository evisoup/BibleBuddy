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
    var date: Int = 0
    var startChapter: Int = 0
    var endChapter: Int = 0
    var startBook: Int = 0
    var endBook: Int = 0
    var finish: Bool = false
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(date, forKey: "date")
        aCoder.encodeInteger(startChapter, forKey: "startChapter")
        aCoder.encodeInteger(endChapter, forKey: "endChapter")
        aCoder.encodeInteger(startBook, forKey: "startBook")
        aCoder.encodeInteger(endBook, forKey: "endBook")
        aCoder.encodeBool(finish, forKey: "finish")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        _ = aDecoder.decodeObjectForKey("date") as? Int
        _ = aDecoder.decodeObjectForKey("startChapter") as? Int
        _ = aDecoder.decodeObjectForKey("endChapter") as? Int
        _ = aDecoder.decodeObjectForKey("startBook") as? Int
        _ = aDecoder.decodeObjectForKey("endBook") as? Int
        _ = aDecoder.decodeObjectForKey("finish") as? Bool
        
        self.init()
    }
}
