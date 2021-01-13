//
//  TableData.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/27.
//

import Foundation
import CoreData
import UIKit

class TableData: NSManagedObject {
    
    @NSManaged var tableID: String
    @NSManaged var tableName: String?
    @NSManaged var hold: String?
    @NSManaged var breath: String?
    
    @NSManaged var set: String?
    @NSManaged var reduce: String?
    @NSManaged var saveDate: String?
    @NSManaged var whitchTable: String?
    
    //日記
    @NSManaged var diaryName: String?
    @NSManaged var diaryDate: String?
    @NSManaged var diaryTextView: String?
    //裝備
    @NSManaged var equipSuit: String?
    @NSManaged var equipMask: String?
    @NSManaged var equipFins: String?
    @NSManaged var equipWeight: String?
    @NSManaged var equipTemperature: String?
    @NSManaged var equipDiveTime: String?
    @NSManaged var equipMaxDeep: String?
    @NSManaged var equipVisibility: String?
    //心情
    @NSManaged var moodEmoji: String?
    //位置
    @NSManaged var locationSiteName: String?
    @NSManaged var locationSiteLat: String?
    @NSManaged var locationSiteLon: String?
    //天氣
    @NSManaged var weatherLocation: String?
    @NSManaged var weatherName: String?
    @NSManaged var weatherTMin: String?
    @NSManaged var weatherTMax: String?
    
    
    override func awakeFromInsert() {
        self.tableID = UUID().uuidString
    }
    
    
}
