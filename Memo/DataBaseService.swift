//
//  DatabaseService.swift
//  Memo
//
//  Created by hui on 16/5/26.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class DataBaseService: NSObject {
    
    var dataBase:FMDatabase!
    var dbQueue:FMDatabaseQueue!
    class var sharedInstance:DataBaseService {
        struct Static {
            static var onceToken:dispatch_once_t = 0
            static var instance:DataBaseService? = nil
        }
        dispatch_once(&Static.onceToken, { () -> Void in
            Static.instance = DataBaseService()
        })
        return Static.instance!
    }
    
    override init(){
        super.init()
        self.dataBase = self.getDataBase()
        self.dbQueue = self.getDataBaseQueue()
    }
    
    func getDataBase() -> FMDatabase{
        let fileManager = NSFileManager.defaultManager()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if !fileManager.fileExistsAtPath(appDelegate.dataBasePath){
            let db = FMDatabase(path: appDelegate.dataBasePath)
            if db == nil{
                print("Error:\(db.lastErrorMessage())")
            }
            if db.open(){
                let sqlStr = "CREATE TABLE IF NOT EXISTS USER(UID TEXT, PHONENUMBER TEXT, NICKNAME TEXT, CURRENTUSER INT, PRIMARY KEY(UID))"
                if !db.executeUpdate(sqlStr, withArgumentsInArray: []) {
                    print("Error:\(db.lastErrorMessage())")
                }
                db.close()
            }
            else{
                print("Error:\(db.lastErrorMessage())")
            }
        }
        return FMDatabase(path: appDelegate.dataBasePath)
    }
    
    func getDataBaseQueue() -> FMDatabaseQueue {
        return FMDatabaseQueue(path: (UIApplication.sharedApplication().delegate as! AppDelegate).dataBasePath)
    }
    
    func selectData(table:String) -> Dictionary<String,AnyObject> {
        self.dataBase.open()
        var dictArr = Dictionary<String, AnyObject>()
        let sqlStr = "SELECT * FROM \(table)"
        let rs:FMResultSet = dataBase.executeQuery(sqlStr, withArgumentsInArray: [])
        while rs.next(){
            let data:NSDictionary = ["title": rs.stringForColumn("TITLE"), "content": rs.stringForColumn("CONTENT"), "createtime": rs.stringForColumn("CREATE_TIME"), "lastedittime": rs.stringForColumn("LAST_EDIT_TIME"), "alerttime": rs.stringForColumn("ALERT_TIME"), "level": rs.longForColumn("LEVEL"), "state": rs.longForColumn("STATE")]
            dictArr["\(rs.stringForColumn("CREATE_TIME"))"] = data
        }
        return dictArr
    }
    
    func insertInDB(data:ItemModel) -> Bool {
        self.dataBase.open()
        let sqlStr = "INSERT INTO data_\(UserVC.currentUser.md5) VALUES (?, ?, ?, ?, ?, ?, ?)"
        let succeed = self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: [data.title, data.content, data.createTime, data.lastEditTime, data.alertTime, data.level, data.state])
        self.dataBase.close()
        //RequestAPI.GET(<#T##url: String!##String!#>, body: <#T##AnyObject?#>, succeed: <#T##Succeed##Succeed##(NSURLSessionDataTask!, AnyObject!) -> Void#>, failed: <#T##Failure##Failure##(NSURLSessionDataTask!, NSError!) -> Void#>)
//        let baseURL = NSURL(string: "http://172.26.209.192/")
//        let manager = AFHTTPSessionManager(baseURL: baseURL)
//        let paramDict:Dictionary = ["UID":UserInfo.UID,"TaskModel":data]
//        let url:String = "todolist/index.php/Home/Task/SynchronizeTask"
//        //请求数据的序列化器
//        manager.requestSerializer = AFHTTPRequestSerializer()
//        //返回数据的序列化器
//        manager.responseSerializer = AFHTTPResponseSerializer()
//        let resSet = NSSet(array: ["text/html"])
//        manager.responseSerializer.acceptableContentTypes = resSet as? Set<String>
//        manager.POST(url, parameters: paramDict, success: { (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
//            //成功回调
//            print("success")
//            
//            let resultDict = try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)
//            
//            print("请求结果：\(resultDict)")
//            let a = resultDict["taskModelArr"] as! NSArray
//            print(a.count)
//            
//            
//        }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
//            //失败回调
//            print("网络调用失败:\(error)")
//        }
        return succeed
    }
    
    
    
    //参数为创建时间
    func deleteInDB(createTime:String) -> Bool {
        self.dataBase.open()
        let sqlStr = "DELETE FROM data_\(UserVC.currentUser.md5) WHERE CREATE_TIME=?"
        let succeed = self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: [createTime])
        self.dataBase.close()
        return succeed
    }
    
    //将修改后的data作为参数，createTime是主键不允许修改。
    func updateInDB(data:ItemModel) -> Bool {
        self.dataBase.open()
        let sqlStr = "UPDATE data_\(UserVC.currentUser.md5) SET TITLE=?, CONTENT=?, LAST_EDIT_TIME=?, ALERT_TIME=?, LEVEL=?, STATE=? WHERE CREATE_TIME=?"
        let succeed = self.dataBase.executeUpdate(sqlStr, withArgumentsInArray: [data.title, data.content, data.lastEditTime, data.alertTime, data.level, data.state, data.createTime])
        self.dataBase.close()
        return succeed
    }
    
    //selectAllInDB().0 是未完成列表，selectAllInDB().1 是已完成列表。
    func selectAllInDB() -> ([ItemModel], [ItemModel]) {
        self.dataBase.open()
        let sqlStr = "SELECT * FROM data_\(UserVC.currentUser.md5) ORDER BY LEVEL, LAST_EDIT_TIME DESC"
        let rs =  self.dataBase.executeQuery(sqlStr, withArgumentsInArray: [])
        var unfinished:[ItemModel] = [ItemModel]()
        var finished:[ItemModel] = [ItemModel]()
        while rs.next(){
            let state = rs.longForColumn("STATE")
            let data = ItemModel(title: rs.stringForColumn("TITLE"), content: rs.stringForColumn("CONTENT"), createTime: rs.stringForColumn("CREATE_TIME"), lastEditTime: rs.stringForColumn("LAST_EDIT_TIME"), alertTime: rs.stringForColumn("ALERT_TIME"), level: rs.longForColumn("LEVEL"), state: state)
            if state & 1 == 0{  //未删除
                if rs.longForColumn("state") & 2 == 2{ //已完成
                    finished.append(data)
                }
                else{
                    unfinished.append(data)
                }
            }
        }
        self.dataBase.close()
        return (unfinished, finished)
    }
    
}
