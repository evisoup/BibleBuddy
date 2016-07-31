//
//  SettingViewController.swift
//  Ctest
//
//  Created by 刘恒邑 on 16/7/30.
//  Copyright © 2016年 Hengyi Liu. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITextFieldDelegate {

    
    
    

    @IBOutlet weak var textField_Date: UITextField!

    
    @IBOutlet weak var endDate: UITextField!
    
    
    
    var datePicker : UIDatePicker!
    
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
        textField_Date.text = dateFormatter1.stringFromDate(datePicker.date)
        textField_Date.resignFirstResponder()
    }
    func cancelClick() {
        textField_Date.resignFirstResponder()
    }
    
    func doneClickB() {
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateStyle = .MediumStyle
        dateFormatter1.timeStyle = .NoStyle
        endDate.text = dateFormatter1.stringFromDate(datePicker.date)
        endDate.resignFirstResponder()
    }
    func cancelClickB() {
        endDate.resignFirstResponder()
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == 1 {
            self.pickUpDate(self.textField_Date)
        } else if textField.tag == 2 {
            self.pickUpDate(self.endDate)
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
    


}
