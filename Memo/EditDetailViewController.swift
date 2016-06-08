//
//  EditDetailViewController.swift
//  toDoList
//
//  Created by Luvian on 16/6/2.
//  Copyright © 2016年 Luvian. All rights reserved.
//

import UIKit

class EditDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var currentList:ItemModel!
    var titleTextField:UITextField!
    var contentTextView:UITextView!
    var timeButton:UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")!.drawInRect(CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        //
        //        let textField = UITextField(frame: CGRectMake(30, 120, self.view.frame.size.width - 60, 50))
        //        textField.layer.borderWidth=1  //边框粗细
        //        textField.layer.borderColor=UIColor.grayColor().CGColor //边框颜色
        //        textField.placeholder = "请输入内容"
        ////        textField.text = self.currentList.toDoList
        //        textField.font = UIFont.boldSystemFontOfSize(20)
        //        textField.textAlignment = .Center
        //        textField.delegate = self
        //
        //        self.view.addSubview(textField)
        //
        //        let textview = UITextView(frame: CGRectMake(30, 180, self.view.frame.size.width - 60, 190))
        //        textview.layer.borderWidth=1
        //        textview.layer.borderColor=UIColor.grayColor().CGColor
        ////        textview.text = self.currentList.detail
        //        textview.font = UIFont.boldSystemFontOfSize(16)
        //        textview.delegate = self
        //
        //        self.view.addSubview(textview)
        
        
        self.title = "编辑"
        //        self.view.backgroundColor = UIColor.grayColor()
        
        //        //导航栏颜色
        //        let mainColor = UIColor(red: 255/255, green: 223/255, blue: 110/255, alpha: 1)
        //        self.navigationController?.navigationBar.barTintColor = mainColor
        //        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //        //        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIFont(name: "Zapfino", size: 24.0)!];
        
        //给导航增加item
        let rightItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditDetailViewController.FinishItem(_:)))
        rightItem.title = "完成"
        self.navigationItem.rightBarButtonItem = rightItem
        
        //标题
        self.titleTextField = UITextField(frame: CGRectMake(15, 20, self.view.frame.size.width - 30, 50))
        self.titleTextField.backgroundColor=UIColor.whiteColor()
        self.titleTextField.layer.cornerRadius = 10;
        self.titleTextField.text = currentList.title
        self.titleTextField.delegate = self
        textFieldShouldReturn(self.titleTextField)
        self.view.addSubview(self.titleTextField)
        
        
        
        //提醒时间边框
        let timeTV = UITextView(frame: CGRectMake(15, self.view.frame.size.height - 160, self.view.frame.size.width - 30, 80))
        timeTV.editable=false
        timeTV.layer.borderColor = UIColor(red: 60/255, green: 40/255, blue: 129/255, alpha: 1).CGColor;
        timeTV.layer.borderWidth = 0.4;
        timeTV.layer.cornerRadius = 10;
        self.view.addSubview(timeTV)
        
        //提醒时间
        let timeLabel = UILabel()
        timeLabel.text = "提醒时间"
        timeLabel.frame = CGRectMake(40, self.view.frame.size.height - 105, (self.view.frame.size.width / 2 )-30, 20)
        timeLabel.font = UIFont(name:"Zapfino", size:15)
        self.view.addSubview(timeLabel)
        
        //显示提醒时间
        self.timeButton = UIButton()
        self.timeButton.frame = CGRectMake(self.view.frame.size.width - 200 , self.view.frame.size.height - 107, (self.view.frame.size.width / 2 )-30, 20)
        self.timeButton.setTitle(currentList.alertTime, forState:UIControlState.Normal)
        self.timeButton.setTitleColor(UIColor.blackColor(),forState: .Normal)
        self.timeButton.addTarget(self, action: #selector(EditDetailViewController.selectDate(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.timeButton)
        
        //添加星级边框
        let starTV = UITextView(frame: CGRectMake(15, self.view.frame.size.height - 195, self.view.frame.size.width - 30, 80))
        starTV.editable=false
        starTV.layer.borderColor = UIColor(red: 60/255, green: 40/255, blue: 129/255, alpha: 1).CGColor;
        starTV.layer.borderWidth = 0.4;
        starTV.layer.cornerRadius = 10;
        self.view.addSubview(starTV)
        
        //添加星级
        let starLabel = UILabel()
        starLabel.text = "添加星级"
        starLabel.frame = CGRectMake(40, self.view.frame.size.height - 140, (self.view.frame.size.width / 2 )-30, 20)
        starLabel.font = UIFont(name:"Zapfino", size:15)
        self.view.addSubview(starLabel)
        
        //大边框
        self.contentTextView = UITextView(frame: CGRectMake(15, 80, self.view.frame.size.width - 30, self.view.frame.size.height - 230))
        
        self.contentTextView.layer.borderColor = UIColor(red: 60/255, green: 40/255, blue: 129/255, alpha: 1).CGColor;
        self.contentTextView.layer.borderWidth = 0.4;
        self.contentTextView.layer.cornerRadius = 10;
        
        let comment_message_style = NSMutableParagraphStyle()
        comment_message_style.firstLineHeadIndent = 24.0
        comment_message_style.headIndent = 10.0
        let comment_message_indent = NSMutableAttributedString(string:
            currentList.content)
        comment_message_indent.addAttribute(NSParagraphStyleAttributeName,
                                            value: comment_message_style,
                                            range: NSMakeRange(0, comment_message_indent.length))
        self.contentTextView.attributedText = comment_message_indent
        
        self.view.addSubview(self.contentTextView)
        
        
        //添加detail
        //        let detailLabel = UILabel()
        //        detailLabel.text = "lalllalallallalalallalllallallalalalalalallalalallallalalalalalalallala"
        //        detailLabel.frame = CGRectMake(45, 85, self.view.frame.size.width - 90, 70)
        //        detailLabel.numberOfLines = 0
        //        detailLabel.textColor = UIColor.grayColor()
        //        self.view.addSubview(detailLabel)
        
        
        
        
        //        //分享按钮
        //        let shareButton:UIButton = UIButton()
        //        shareButton.frame=CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width / 2, 60)
        //        shareButton.setTitle("分享", forState:UIControlState.Normal)
        //        shareButton.backgroundColor=UIColor(red: 238/255, green: 64/255, blue: 86/255, alpha:1)
        //        self.view.addSubview(shareButton)
        //
        //        //删除按钮
        //        let deleteButton:UIButton = UIButton()
        //        deleteButton.frame=CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height - 60, self.view.frame.size.width / 2, 60)
        //        deleteButton.setTitle("删除", forState:UIControlState.Normal)
        //        deleteButton.backgroundColor=UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha:1)
        //        self.view.addSubview(deleteButton)
        
        
        
        //        let button:UIButton = UIButton()
        //        button.frame=CGRectMake(30, 400, self.view.frame.size.width - 60, 30)
        //        button.setTitle("编辑完成", forState:UIControlState.Normal)
        //        button.setTitleColor(UIColor.grayColor(),forState: .Highlighted)
        //        button.backgroundColor=UIColor(red: 238/255, green: 64/255, blue: 86/255, alpha:1)
        //        self.view.addSubview(button);
        //
        //        button.addTarget(self,action:#selector(EditViewController.tapped(_:)),forControlEvents:UIControlEvents.TouchUpInside)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func FinishItem(right:UIBarButtonItem)
    {
        currentList.title = self.titleTextField.text!
        currentList.content = self.contentTextView.text!

        UnfinishedVC.updateData(currentList)
       
        UnfinishedVC.hidesBottomBarWhenPushed = false;
        self.navigationController?.popToRootViewControllerAnimated(true)
//        self.navigationController?.pushViewController(UnfinishedVC, animated: true)
        
    }
    
    func selectDate(sender: AnyObject) {
        
        let alertController:UIAlertController=UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let datePicker = UIDatePicker( )
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        datePicker.date = NSDate()
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default){
            (alertAction)->Void in
            print("date select: \(datePicker.date.description)")
            self.currentList.alertTime=datePicker.date.description
            //刷新表面数据
            self.timeButton.setTitle(self.currentList.alertTime, forState:UIControlState.Normal)
            
            //            self.Datebutt.setNeedsDisplay()
            })
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler:nil))
        
        alertController.view.addSubview(datePicker)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(TextField: UITextField) -> Bool
    {
        TextField.resignFirstResponder()
        return true;
    }
    
    
}
