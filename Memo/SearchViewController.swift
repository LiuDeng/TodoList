//
//  SearchViewController.swift
//  Memo
//
//  Created by tjiese on 16/6/3.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchResultsUpdating, UISearchBarDelegate {
    
    let cellIdentifier:String = "ItemCell"
    var mainTableView:UITableView = UITableView()
//    private var originConstant: CGFloat = 0
    var dataArr:[ItemModel] = [ItemModel]()
//    var dataArr1:[ItemModel]!
    var isFinished:Bool!    //表示当前标签页是"已完成"还是"未完成"。
    var dataBase:FMDatabase!
    var dbQueue:FMDatabaseQueue!
    
    
    var tabledata:[String] = []
    var searchActive : Bool = false
    
    var filtered:[ItemModel] = [ItemModel]()
//    var editVC = EditController()
    //    var resultSearchController : UISearchController = UISearchController()
//    lazy   var searchBar:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))
//    lazy var search:UITextField = UITextField(frame: CGRectMake(0, 0, 200, 20))
    var searchController:UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        let tableViewFrame:CGRect = self.view.bounds
        self.mainTableView = UITableView(frame: tableViewFrame, style: UITableViewStyle.Plain)
        self.mainTableView.backgroundColor = UIColor.whiteColor()
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        let cellNib = UINib(nibName: "ItemCell", bundle: nil)
        self.mainTableView.registerNib(cellNib, forCellReuseIdentifier: cellIdentifier)
        self.mainTableView.tableFooterView = UIView()
        self.view.addSubview(self.mainTableView)
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")!.drawInRect(CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        self.mainTableView.backgroundColor = UIColor.clearColor()
        self.mainTableView.separatorStyle = .None

        
        
        
//        self.dataBase.open()
//        
//        self.dataBase.close()
        
        let resetButton = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("reset"))
        //        self.resultSearchController = ({
        //            let controller = UISearchController(searchResultsController: nil)
        //            controller.searchResultsUpdater = self
        ////            controller.
        //            controller.dimsBackgroundDuringPresentation = false
        //            controller.searchBar.sizeToFit()
        //
        //            self.mainTableView.tableHeaderView = controller.searchBar
        //
        //            return controller
        //        })()
//        searchController.searchBar = UISearchBar()
        searchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        
        self.dataArr.appendContentsOf(DataBaseService.sharedInstance.selectAllInDB().0)
        self.dataArr.appendContentsOf(DataBaseService.sharedInstance.selectAllInDB().1)
//        print(self.dataArr)
//        onInput()
//        var searchBarStyle: UISearchBarStyle = .Minimal
//        searchBar.sizeToFit().addTarget(self,action:"onInput",forControlEvents:)
//        search.addTarget(self, action: "onInput", forControlEvents: .AllEditingEvents)
//        search.backgroundColor = UIColor.clearColor()
//        navigationItem.titleView = searchController.searchBar
        self.mainTableView.tableHeaderView = self.searchController.searchBar
        self.navigationItem.leftBarButtonItem = resetButton
        // Reload the table
        self.mainTableView.reloadData()
    }
    
//    func onInput() {
//        //            tabledata.append(i.title)
////            tabledata.append(i.title)
//
//        var index = 0
//        self.dataArr = FinishedVC.selectAllInDB().0
//        for i in self.dataArr {
////            if i.title == searchBar.text || i.content == searchBar.text {
////            tabledata[index]
//            index++
////            }
//        }
//        self.dataArr.appendContentsOf(FinishedVC.selectAllInDB().1)
//        for i in self.dataArr {
////            if i.title == searchBar.text || i.content == searchBar.text {
//                tabledata[index] = i.title
//                index++
////            }
//        }
//    }
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
//        filtered = dataArr.filter({ (text) -> Bool in
//            let tmp: NSString = text
//            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
//            return range.location != NSNotFound
//        })
        
        self.updateSearchResultsForSearchController(self.searchController!)
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.mainTableView.reloadData()
    }

    
    
    func reset() {
//        let nav = BaseViewController()
        self.navigationController!.popViewControllerAnimated(true)
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if self.searchBar.active {
        //            return self.filteredTableData.count
        //        }else{
//        return self.tabledata.count
        //        }
//        if(searchActive) {
            return filtered.count
//        }
//        return self.dataArr.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var section = indexPath.section
//        var row = indexPath.row
//        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier:"ItemCell")
//        cell.selectionStyle =  UITableViewCellSelectionStyle.None
//        cell.backgroundColor = UIColor.clearColor()
//        cell.contentView.backgroundColor = UIColor.clearColor()
//        cell.textLabel?.textAlignment = NSTextAlignment.Left
//        cell.textLabel?.textColor = UIColor.blackColor()
//        cell.textLabel?.font = UIFont.systemFontOfSize(14.0)
//        
//        //        if self.searchBar.active {
//        //            cell.textLabel?.text = filteredTableData[indexPath.row]
//        //        } else {
//        cell.textLabel?.text = tabledata[indexPath.row]
//        //        }
//        return cell
//        
        
        let cell = mainTableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ItemCell
        
        if(searchActive){
            let item = self.filtered[indexPath.row]
            cell.titleLabel.text = item.title
            cell.timeLabel.text = friendlyTime(item.lastEditTime)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        } else {
            let item = self.dataArr[indexPath.row]
            cell.titleLabel.text = item.title
            cell.timeLabel.text = friendlyTime(item.lastEditTime)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        return cell
//        return FinishedVC.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    func filterContentForSearchText(searchText: String) {
        
        filtered = self.dataArr.filter({ ( itemModel: ItemModel) -> Bool in
            
            let titleMatch = itemModel.title.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            let contentMatch = itemModel.content.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            
            return titleMatch != nil || contentMatch != nil
            
        })
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        
        filterContentForSearchText(searchText!)
        //        filtered.removeAll(keepCapacity: false)
//        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
//        
//        let array = (dataArr as NSArray).filteredArrayUsingPredicate(searchPredicate)
//        filtered = array as! [ItemModel]
        self.mainTableView.reloadData()
        
    }
    
    //显示友好时间戳，参考自http://blog.csdn.net/zhyl8157121/article/details/42155921
    func friendlyTime(dateTime: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "zh_CN")
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss")
        if let date = dateFormatter.dateFromString(dateTime) {
            let delta = NSDate().timeIntervalSinceDate(date)
            if (delta < 60) {
                return "刚刚"
            }
            else if (delta < 3600) {
                return "\(Int(delta / 60))分钟前"
            }
            else {
                let calendar = NSCalendar.currentCalendar()
                let unitFlags:NSCalendarUnit = [.Year,.Month,.Day,.Hour,.Minute]
                
                let comp = calendar.components(unitFlags, fromDate: NSDate())
                let currentYear = String(comp.year)
                let currentDay = String(comp.day)
                
                let comp2 = calendar.components(unitFlags, fromDate: date)
                let year = String(comp2.year)
                let month = String(comp2.month)
                let day = String(comp2.day)
                var hour = String(comp2.hour)
                var minute = String(comp2.minute)
                
                if comp2.hour < 10 {
                    hour = "0" + hour
                }
                if comp2.minute < 10 {
                    minute = "0" + minute
                }
                
                if currentYear == year {
                    if currentDay == day {
                        return "\(hour):\(minute)"
                    } else {
                        return "\(month)/\(day)"
                    }
                } else {
                    return "\(year)/\(month)/\(day)"
                }
            }
        }
        return ""
    }
}