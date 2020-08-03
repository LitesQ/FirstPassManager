//
//  RegistrationController.swift
//  FirstPassManager
//
//  Created by loka on 27.04.2020.
//  Copyright © 2020 loka. All rights reserved.
//

import Cocoa

class RegistrationController: NSViewController {
    @IBOutlet weak var LoginField: NSTextField!
    @IBOutlet weak var PasswordField: NSTextField!
    @IBOutlet weak var Error_Label: NSTextField!
    
    var SecureKey: String = "";
    
    @IBAction func NextButton_Action(_ sender: Any) {
        Error_Label.stringValue = ""
        if(LoginField.stringValue == ""){
            Error_Label.stringValue = "Логин не может быть пустым"
            return
        }
        if(PasswordField.stringValue == ""){
            Error_Label.stringValue = "Пароль не может быть пустым"
            return
        }
        
        let Login = LoginField.stringValue;
        let Password = PasswordField.stringValue;
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.0.4/FirstPass/RegisterUser.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(Login)&b=\(Password)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        var responseString: NSString = "";
        var errorFlag: Bool = false;
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                //print("error=\(String(describing: error))")
                errorFlag = true;
                return
            }
            
            responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            //print("responseString = \(String(describing: responseString))")
        }
        task.priority = 1;
        task.resume()
        
        repeat{
            sleep(1/2);
        }while (responseString == "" && errorFlag == false)
        
        if(errorFlag != true){
            if (responseString == "AlreadyUsed"){
                Error_Label.stringValue = "Указанное имя пользователя занято";
                return;
            }
            else{
                SecureKey = responseString as String;
                UserDefaults.standard.set(SecureKey, forKey: "SecureKey");
                UserDefaults.standard.synchronize();
                
                let nextViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "FinishRegistrationView1")) as? NSViewController
                if let window = view.window{
                    nextViewController?.view.frame = window.frame
                }
                presentViewController(nextViewController!, animator: ReplacePresentationAnimator())
                dismissViewController(self)
            }
            responseString = "";
        }
        else if (errorFlag == true){
            Error_Label.stringValue = "Ошибка подключения к серверу";
            return;
        }
        
    }
    
    @IBAction func CancelButton_Action(_ sender: Any) {

        let nextViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "AuthentificationViewController")) as? NSViewController
        if let window = view.window{
            nextViewController?.view.frame = window.frame
        }
        presentViewController(nextViewController!, animator: ReplacePresentationAnimator())
        dismissViewController(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do view setup here.
    }
    
}
