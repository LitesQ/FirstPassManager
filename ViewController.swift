//
//  ViewController.swift
//  FirstPassManager
//
//  Created by loka on 26.04.2020.
//  Copyright © 2020 loka. All rights reserved.
//

import Cocoa


class ViewController: NSViewController {

    @IBOutlet weak var LoginField: NSTextField!
    @IBOutlet weak var PasswordField: NSTextField!
    @IBOutlet weak var SecureKeyField: NSTextField!
    @IBOutlet weak var Error_Label: NSTextField!
    
    @IBOutlet weak var AuthButton: NSButton!
    @IBOutlet weak var RegButton: NSButton!
    
    
    @IBAction func AuthorisationButton_Action(_ sender: Any) {
        let Login = LoginField.stringValue;
        let Password = PasswordField.stringValue;
        let SecureKey = SecureKeyField.stringValue;
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.0.4/FirstPass/Authorisation.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(Login)&b=\(Password)&c=\(SecureKey)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        var responseString: NSString = "";
        var errorFlag:Bool = false;
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                //print("error=\(String(describing: error))")
                errorFlag = true;
                return
            }
            //print("response = \(String(describing: response))")
            
            responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            //print("responseString = \(String(describing: responseString))")
            
        }
        task.priority = 1;
        task.resume()
        task.priority = 1;
        
        repeat{
            sleep(1/2);
        }while (responseString == "" && errorFlag == false)
        
        if (errorFlag != true){
            if (responseString == "ErrorUser"){
                self.Error_Label.stringValue = "Неверное имя пользователя";
                return;
            }
            else if (responseString == "ErrorPassword"){
                self.Error_Label.stringValue = "Неверный пароль";
                return;
            }
            else if (responseString == "ErrorSecureKey"){
                self.Error_Label.stringValue = "Неверный Secure-Key";
                return;
            }
            else if (responseString == "AuthSucceed"){
                
                UserDefaults.standard.set(Login, forKey: "Login");
                UserDefaults.standard.set(Password, forKey: "Password");
                UserDefaults.standard.set(SecureKey, forKey: "SecureKey");
                UserDefaults.standard.synchronize();
                
                let vc = MainViewController()
                vc.get(flag: false, trashflag: false,searchflag: false)
                
                let nextViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "MainViewController")) as? NSViewController
                if let window = view.window{
                    nextViewController?.view.frame = window.frame
                }
                presentViewController(nextViewController!, animator: ReplacePresentationAnimator())
                return;
            }
            responseString = "";
        }
        else if (errorFlag == true){
            Error_Label.stringValue = "Ошибка подключения к серверу";
            return;
        }
        
    }
    
    @IBAction func RegButton_Action(_ sender: Any) {
        let nextViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "RegistrationViewController")) as? NSViewController
        if let window = view.window{
            nextViewController?.view.frame = window.frame
        }
        presentViewController(nextViewController!, animator: ReplacePresentationAnimator())
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (UserDefaults.standard.string(forKey: "SecureKey") != nil){
            SecureKeyField.stringValue = UserDefaults.standard.string(forKey: "SecureKey")!
        }
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

