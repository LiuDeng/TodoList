//
//  ChangeNicknameController.swift
//  Memo
//
//  Created by tjise on 16/6/7.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class ChangeNicknameController: UIViewController,UITextFieldDelegate ,UITableViewDelegate,UITableViewDataSource{

   // var nicknameTextField:UITextField!
    var isNicknameChanged:Bool = false
    var nicknameText:UITextField!
    var mainTableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改昵称"
        //self.setNicknameTextField()
        self.setTableView()
        self.addLeftButtonItem()
        self.addRightButtonItem()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    
//    //设置昵称输入框
//    func setNicknameTextField(){
//        let frame:CGRect = CGRectMake(10, 15, self.view.bounds.size.width-20,30)
//        self.nicknameTextField = UITextField(frame: frame)
//        self.nicknameTextField.borderStyle = .RoundedRect
//        self.nicknameTextField.layer.borderWidth = 1.0
//        self.nicknameTextField.becomeFirstResponder()
//        self.nicknameTextField.placeholder = "请输入用户昵称"
//        self.nicknameTextField.text = UserInfo.nickname
//        self.nicknameTextField.keyboardType = .Default
//        self.nicknameTextField.delegate = self
//        self.nicknameTextField.leftView = UIView(frame:CGRectMake(0, 0, 44, 44))
//        self.nicknameTextField.leftViewMode = UITextFieldViewMode.Always
//        let imgUser =  UIImageView(frame:CGRectMake(11, 11, 22, 22))
//        imgUser.image = UIImage(named:"灰手机")
//        self.nicknameTextField.leftView!.addSubview(imgUser)
//        self.view.addSubview(nicknameTextField)
//    }
    
    //设置修改密码的tableView
    func setTableView(){
        let tableViewFrame:CGRect = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        self.mainTableView = UITableView(frame: tableViewFrame, style: .Plain)
        self.mainTableView.dataSource = self
        self.mainTableView.delegate = self
        self.mainTableView.backgroundColor = .clearColor()
        self.mainTableView.separatorStyle = .None
        self.mainTableView.scrollEnabled = false
        self.view.addSubview(self.mainTableView)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    
    //行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    //修改密码的tableView样式。
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let frame:CGRect = CGRectMake(0, 10, self.view.bounds.size.width, 100)
        let cell = UITableViewCell(frame: frame)
        cell.textLabel?.text = "新昵称： "
        cell.selectionStyle = .None
        let textFrame:CGRect = CGRectMake(100,10,self.view.bounds.size.width - 110,40)
        nicknameText = UITextField(frame: textFrame)
        nicknameText.text = UserInfo.nickname
        nicknameText.textAlignment = .Left
        nicknameText.layer.cornerRadius = 5
        nicknameText.textColor = UIColor.blackColor()
        nicknameText.layer.borderWidth = 1
        nicknameText.borderStyle = .RoundedRect
        cell.addSubview(nicknameText)
        return cell
    }
    
    //行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //设置返回按钮
    func addLeftButtonItem(){
        let leftBtn:UIBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "backPersonalCenter")
        self.navigationItem.leftBarButtonItem = leftBtn
    }
    
    //设置修改密码完成按钮
    func addRightButtonItem(){
        let rightBtn = UIBarButtonItem(title: "完成", style: .Plain, target: self, action: "updateNickname")
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    func backPersonalCenter(){
        self.navigationController?.popViewControllerAnimated(true)
    }

    func updateNickname() -> Void{
        let nickname = self.nicknameText.text! as String
        let reachability = Reachability.reachabilityForInternetConnection()
        if nickname == "" || nickname == UserInfo.nickname{
            self.navigationController?.popViewControllerAnimated(true)
        }
        else if !reachability!.isReachable(){
            self.showAlert("网络连接失败")
        }
        else{
            let url:String = "todolist/index.php/Home/User/ChangeNickname"
            let paramDict = ["UID":UserInfo.UID, "user_newNickname":nickname]
            RequestAPI.POST(url, body: paramDict, succeed: { (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
                let resultDict = try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)
                if resultDict["isSuccess"] as! Int == 1 {
                    UserInfo.nickname = nickname
                    DatabaseService.sharedInstance.updateNickname()
                    self.navigationController?.popViewControllerAnimated(true)
                }
                else{
                    self.showAlert("上传数据失败")
                }
            }, failed: { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
                self.showAlert("上传数据失败")
            })
        }
    }
    
    func showAlert(message:String){
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (cancelAction) in
            if message == "上传数据失败"{
                self.navigationController?.popViewControllerAnimated(true)
            }
        })
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

}