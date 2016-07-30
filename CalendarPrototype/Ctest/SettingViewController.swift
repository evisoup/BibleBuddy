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
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "doneClick")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelClick")
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
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.pickUpDate(self.textField_Date)
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
