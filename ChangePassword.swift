//
//  ChangePassword.swift
//  FirstPassManager
//
//  Created by loka on 06.05.2020.
//  Copyright © 2020 loka. All rights reserved.
//

import Cocoa

class ChangePassword: NSViewController {

    @IBOutlet weak var OldPasswordSecure: NSSecureTextField!
    @IBOutlet weak var NewPasswordSecure: NSSecureTextField!
    @IBOutlet weak var RepeatPasswordSecure: NSSecureTextField!
    
    @IBOutlet weak var OldPasswordNonSecure: NSTextField!
    @IBOutlet weak var NewPasswordNonSecure: NSTextField!
    @IBOutlet weak var RepeatPasswordNonSecure: NSTextField!
    
    @IBOutlet weak var ErrorLabel: NSTextField!
    
    
    @IBAction func CangePassword_Action(_ sender: Any) {
        ErrorLabel.stringValue = ""
        let OldPass = UserDefaults.standard.object(forKey: "Password").unsafelyUnwrapped
        var NewPass = ""
        
        if (OldPasswordSecure.isHidden == false){
            if (OldPasswordSecure.stringValue != OldPass as! String){
                ErrorLabel.stringValue = "Неверный пароль"
                return
            }
        }
        else{
            if (OldPasswordNonSecure.stringValue != OldPass as! String){
                ErrorLabel.stringValue = "Неверный пароль"
                return
            }
        }
        
        if ((NewPasswordSecure.stringValue == "" && NewPasswordNonSecure.stringValue == "") || (RepeatPasswordSecure.stringValue == "" && RepeatPasswordNonSecure.stringValue == "")){
            ErrorLabel.stringValue = "Поля не могут быть пустыми"
            return
        }
        
        if (NewPasswordSecure.isHidden == false){
            if(RepeatPasswordSecure.isHidden == false){
                if (NewPasswordSecure.stringValue != RepeatPasswordSecure.stringValue){
                    ErrorLabel.stringValue = "Пароли не совпадают"
                    return
                }
                else{
                    NewPass = NewPasswordSecure.stringValue
                }
            }
            else{
                if (NewPasswordSecure.stringValue != RepeatPasswordNonSecure.stringValue){
                    ErrorLabel.stringValue = "Пароли не совпадают"
                    return
                }
                else{
                    NewPass = NewPasswordSecure.stringValue
                }
            }
        }
        else{
            if(RepeatPasswordSecure.isHidden == false){
                if (NewPasswordNonSecure.stringValue != RepeatPasswordSecure.stringValue){
                    ErrorLabel.stringValue = "Пароли не совпадают"
                    return
                }
                else {
                    NewPass = NewPasswordNonSecure.stringValue
                }
            }
            else{
                if (NewPasswordNonSecure.stringValue != RepeatPasswordNonSecure.stringValue){
                    ErrorLabel.stringValue = "Пароли не совпадают"
                    return
                }
                else {
                    NewPass = NewPasswordNonSecure.stringValue
                }
            }
        }
        
        let Login = UserDefaults.standard.object(forKey: "Login").unsafelyUnwrapped
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.0.4/FirstPass/ChangePassword.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(Login)&b=\(NewPass)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        var responseString: NSString = "";
        var errorFlag: Bool = false;
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                errorFlag = true;
                return
            }
            
            responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
        }
        task.priority = 1;
        task.resume()
        
        repeat{
            sleep(1/2);
        }while (responseString == "" && errorFlag == false)
        
        UserDefaults.standard.set(NewPass as String, forKey: "Password");
        UserDefaults.standard.synchronize();
        
        dismiss(self)
    }
    
    var flag1: Bool = false;
    var flag2: Bool = false;
    var flag3: Bool = false;

    
    @IBAction func ShowOldPassword_Action(_ sender: Any) {
        if (flag1 == false){
            OldPasswordNonSecure.stringValue = OldPasswordSecure.stringValue
            OldPasswordNonSecure.isHidden = false
            OldPasswordSecure.isHidden = true
            flag1 = true
        }
        else{
            OldPasswordSecure.stringValue = OldPasswordNonSecure.stringValue
            OldPasswordNonSecure.isHidden = true
            OldPasswordSecure.isHidden = false
            flag1 = false
        }
    }
    
    @IBAction func ShowNewPassword_Action(_ sender: Any) {
        if (flag2 == false){
            NewPasswordNonSecure.stringValue = NewPasswordSecure.stringValue
            NewPasswordNonSecure.isHidden = false
            NewPasswordSecure.isHidden = true
            flag2 = true
        }
        else{
            NewPasswordSecure.stringValue = NewPasswordNonSecure.stringValue
            NewPasswordNonSecure.isHidden = true
            NewPasswordSecure.isHidden = false
            flag2 = false
        }
    }
    
    @IBAction func ShowRepeatPassword_Action(_ sender: Any) {
        if (flag3 == false){
            RepeatPasswordNonSecure.stringValue = RepeatPasswordSecure.stringValue
            RepeatPasswordNonSecure.isHidden = false
            RepeatPasswordSecure.isHidden = true
            flag3 = true
        }
        else{
            RepeatPasswordSecure.stringValue = RepeatPasswordNonSecure.stringValue
            RepeatPasswordNonSecure.isHidden = true
            RepeatPasswordSecure.isHidden = false
            flag3 = false
        }
    }
    
    @IBAction func BackButton_Action(_ sender: Any) {
        dismiss(self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
