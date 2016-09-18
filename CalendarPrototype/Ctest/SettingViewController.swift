//
//  SettingViewController.swift
//  Ctest
//
//  Created by 刘恒邑 on 16/7/30.
//  Copyright © 2016年 Hengyi Liu. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITextFieldDelegate {

    var datePicker : UIDatePicker!
    var beginRecord : NSDate!
    var endRecord: NSDate!
    var myPlan: ReadingPlan!
    
    

    @IBOutlet weak var beginDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    
    @IBOutlet weak var totalDays: UILabel!
    @IBOutlet weak var planBegin: UILabel!
    @IBOutlet weak var planEnd: UILabel!
    
    @IBAction func confirmPlan(sender: AnyObject) {

        do {
            try myPlan = ReadingPlan.CreateReadingPlan(0, endAtBook: 65, startDate: beginRecord, endDate: endRecord)
            TempPlan.plan = myPlan

            let dateFormatter1 = NSDateFormatter()
            dateFormatter1.dateStyle = .MediumStyle
            dateFormatter1.timeStyle = .NoStyle
            
            let myStart = TempPlan.plan.startDate
            let myEnd = TempPlan.plan.endDate
            
            planBegin.text =  "From: " + BibleIndex.BibleBookName[TempPlan.plan.startBook ] + " Date: " + dateFormatter1.stringFromDate(myStart)
            planEnd.text = "To: " + BibleIndex.BibleBookName[TempPlan.plan.endBook ] + " Date: " + dateFormatter1.stringFromDate(myEnd)

            
        } catch {
            //TO-DO: ADD UI ALERT AND CLEAR OUT ALL THE DATE
            print("Something went wrong!")
        }
        
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func pickUpDate(textField : UITextField){
        
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRectMake(0, 0, self.view.frame.size.width, 216))
        self.datePicker.backgroundColor = UIColor.whiteColor()
        self.datePicker.datePickerMode = UIDatePickerMode.Date
        textField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        //toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.tintColor = UIColor.redColor()
        toolBar.sizeToFit()
        
        // Adding Button ToolBar

        var doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(SettingViewController.doneClick))
        var spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        var cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(SettingViewController.cancelClick))
        
        if textField.tag == 2 {
            toolBar.tintColor = UIColor.greenColor()
             doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(SettingViewController.doneClickB))
             spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
             cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(SettingViewController.cancelClickB))
        }
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    func doneClick() {
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateStyle = .MediumStyle
        dateFormatter1.timeStyle = .NoStyle
        beginDate.text = dateFormatter1.stringFromDate(datePicker.date)
        
        beginRecord = datePicker.date
        beginDate.resignFirstResponder()
    }
    func cancelClick() {
        beginDate.resignFirstResponder()
    }
    
    func doneClickB() {
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateStyle = .MediumStyle
        dateFormatter1.timeStyle = .NoStyle
        endDate.text = dateFormatter1.stringFromDate(datePicker.date)
        endRecord = datePicker.date
        endDate.resignFirstResponder()

        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day], fromDate: beginRecord, toDate: endRecord, options: [])
        
        print(beginRecord)
        print(endRecord)
        totalDays.text = String( components.day)
        print("DAYS LEFT :" , components.day)
        
    }
    func cancelClickB() {
        endDate.resignFirstResponder()
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == 1 {
            self.pickUpDate(self.beginDate)
        } else if textField.tag == 2 {
            self.pickUpDate(self.endDate)
        }
        

    }



}
