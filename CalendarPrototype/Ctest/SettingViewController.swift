//
//  SettingViewController.swift
//  Ctest
//
//  Created by 刘恒邑 on 16/7/30.
//  Copyright © 2016年 Hengyi Liu. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate {

    var datePicker : UIDatePicker!
    var beginRecord : NSDate!
    var endRecord: NSDate!
    var beginBook: Int = 0
    var endBook: Int = 65
    var myPlan: ReadingPlan!
    var pickOption = [" "] + BibleIndex.BibleBookName
    

    @IBOutlet weak var beginDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var beginChap: UITextField!
    @IBOutlet weak var endChap: UITextField!
    
    @IBOutlet weak var totalDays: UILabel!
    @IBOutlet weak var planBegin: UILabel!
    @IBOutlet weak var planEnd: UILabel!
    @IBOutlet weak var confirmPlanButton: UIButton!

    
    @IBAction func confirmPlan(sender: AnyObject) {

        do {
            try myPlan = ReadingPlan.CreateReadingPlan(beginBook, endAtBook: endBook, startDate: beginRecord, endDate: endRecord)

            myPlan.SaveReadingPlan()
            let dateFormatter1 = NSDateFormatter()
            dateFormatter1.dateStyle = .MediumStyle
            dateFormatter1.timeStyle = .NoStyle
            
            let myStart = myPlan.startDate
            let myEnd = myPlan.endDate
            
            planBegin.text =  BibleIndex.BibleBookName[myPlan.startBook] + " Date: " + dateFormatter1.stringFromDate(myStart)
            planEnd.text = BibleIndex.BibleBookName[myPlan.endBook] + " Date: " + dateFormatter1.stringFromDate(myEnd)
            //confirmPlanButton.enabled = false
            canIConfirmPlan()

            
        } catch CreatingReadingPlanError.TotalReadingDaysNotPositive {
            // create the alert
            let alert = UIAlertController(title: "Warning", message: "Invalid date range!", preferredStyle: .Alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))

            // show the alert
            presentViewController(alert, animated: true, completion: nil)
            return
        } catch CreatingReadingPlanError.TotoalReadingBooksNotPositive {
            // create the alert
            let alert = UIAlertController(title: "Warning", message: "Invalid book range!", preferredStyle: .Alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))

            // show the alert
            presentViewController(alert, animated: true, completion: nil)
            return
        } catch {
            print("The program should not reach here, but I will let it continue")
        }
        
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        canIConfirmPlan()
        //confirmPlanButton.enabled = false
        
        // Do any additional setup after loading the view.
        // Load existing reading plan and display it
        if let myPlan = ReadingPlan.plan {
            let dateFormatter1 = NSDateFormatter()
            dateFormatter1.dateStyle = .MediumStyle
            dateFormatter1.timeStyle = .NoStyle

            let myStart = myPlan.startDate
            let myEnd = myPlan.endDate

            planBegin.text =  BibleIndex.BibleBookName[myPlan.startBook] + " Date: " + dateFormatter1.stringFromDate(myStart)
            planEnd.text =  BibleIndex.BibleBookName[myPlan.endBook] + " Date: " + dateFormatter1.stringFromDate(myEnd)
        }




        let pickerView = UIPickerView()
        pickerView.delegate = self
        beginChap.inputView = pickerView
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.redColor()
        toolBar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(SettingViewController.cancelClick1))
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(SettingViewController.donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        toolBar.setItems([cancelButton,flexSpace,doneButton], animated: false)
        beginChap.inputAccessoryView = toolBar

        let pickerView2 = UIPickerView()
        pickerView2.delegate = self
        endChap.inputView = pickerView2
        let toolBar2 = UIToolbar()
        toolBar2.barStyle = .Default
        toolBar2.translucent = true
        toolBar2.tintColor = UIColor.redColor()
        toolBar2.sizeToFit()
        let cancelButton2 = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(SettingViewController.cancelClick1))
        let doneButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(SettingViewController.donePressed))
        let flexSpace2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        toolBar2.setItems([cancelButton2,flexSpace2,doneButton2], animated: false)
        endChap.inputAccessoryView = toolBar2





    }


    func pickUpDate(textField : UITextField){
        
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRectMake(0, 0, self.view.frame.size.width, 216))
        //self.datePicker.backgroundColor = UIColor.whiteColor()
        self.datePicker.datePickerMode = UIDatePickerMode.Date
        textField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.redColor()
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        
        var doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(SettingViewController.doneClick))
        var spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        var cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(SettingViewController.cancelClick))
        
        if textField.tag == 2 {
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
        canIConfirmPlan()
        beginDate.resignFirstResponder()
    }
    func cancelClick() {
        beginDate.resignFirstResponder()
    }
    
    func doneClickB() {
        //confirmPlanButton.enabled = true
        canIConfirmPlan()
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateStyle = .MediumStyle
        dateFormatter1.timeStyle = .NoStyle
        endDate.text = dateFormatter1.stringFromDate(datePicker.date)
        endRecord = datePicker.date
        canIConfirmPlan()
        endDate.resignFirstResponder()

        let calendar = NSCalendar.currentCalendar()
        guard let beginRecord = beginRecord else {
            return
        }

        let components = calendar.components([.Day], fromDate: beginRecord, toDate: endRecord, options: [])
        
        print(beginRecord)
        print(endRecord)
        totalDays.text = " Days in Total:  \(String( components.day))"
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


////////////////////////////////////NEW PICKER
    func donePressed(sender: UIBarButtonItem) {
        canIConfirmPlan()
        if beginChap.isFirstResponder() {
            beginChap.resignFirstResponder()
        } else if endChap.isFirstResponder() {
            endChap.resignFirstResponder()
        }
    }
    func cancelClick1() {
        if beginChap.isFirstResponder() {
            beginChap.resignFirstResponder()
        } else if endChap.isFirstResponder() {
            endChap.resignFirstResponder()
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if beginChap.isFirstResponder() {
            beginChap.text = pickOption[row]
            beginBook = row - 1
        } else if endChap.isFirstResponder() {
            endChap.text = pickOption[row]
            endBook = row - 1
        }
    }


    func canIConfirmPlan() {
       confirmPlanButton.enabled = cHelper(beginChap.text) && cHelper(endChap.text) && cHelper(beginRecord) && cHelper(endRecord)

    }

    func cHelper(nonNil: AnyObject?) -> Bool{
        if  nonNil != nil {
            if let str = nonNil as? String {
                return str != " " && str != ""
            } else {
                return true
            }
        }
        return false
    }
}
