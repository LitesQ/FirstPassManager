//
//  UserProfileView.swift
//  FirstPassManager
//
//  Created by loka on 01.05.2020.
//  Copyright © 2020 loka. All rights reserved.
//

import Cocoa

class UserProfileView: NSViewController {

    
    @IBOutlet weak var UserName: NSTextField!
    
    
    @IBAction func Back_Action(_ sender: Any) {
        let nextViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "MainViewController")) as? NSViewController
        if let window = view.window{
            nextViewController?.view.frame = window.frame
        }
        presentViewController(nextViewController!, animator: ReplacePresentationAnimator())
        dismissViewController(self)
    }
    
    @IBAction func Exit_Action(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "Login");
        UserDefaults.standard.set(nil, forKey: "Password");
        UserDefaults.standard.set(nil, forKey: "SecureKey");
        UserDefaults.standard.synchronize();
        
        let nextViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "AuthentificationViewController")) as? NSViewController
        if let window = view.window{
            nextViewController?.view.frame = window.frame
        }
        presentViewController(nextViewController!, animator: ReplacePresentationAnimator())
        dismissViewController(self)
    }
    
    @IBAction func Generate_SecureKey(_ sender: Any) {
        let Login = UserName.stringValue
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.0.4/FirstPass/ChangeSecureKey.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(Login)"
        
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

        UserDefaults.standard.set(responseString as String, forKey: "SecureKey");
        UserDefaults.standard.synchronize();
        responseString = "";
        
        performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "GoToNewSecureKey"), sender: self)
    }
    
    @IBAction func Change_Password(_ sender: Any) {
        performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "GoToChangePassword"), sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserName.stringValue = UserDefaults.standard.object(forKey: "Login").unsafelyUnwrapped as! String;
        // Do view setup here.
    }
    
}
