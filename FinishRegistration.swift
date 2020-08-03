//
//  FinishRegistration.swift
//  FirstPassManager
//
//  Created by loka on 27.04.2020.
//  Copyright © 2020 loka. All rights reserved.
//

import Cocoa

class FinishRegistration: NSViewController {

    @IBOutlet weak var SecureKey_Label: NSTextField!
    
    var SecureKeyData: String = "";
    
    @IBAction func FinishButton_Action(_ sender: Any) {
        let nextViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "AuthentificationViewController")) as? NSViewController
        if let window = view.window{
            nextViewController?.view.frame = window.frame
        }
        presentViewController(nextViewController!, animator: ReplacePresentationAnimator())
        dismissViewController(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let key = UserDefaults.standard.string(forKey: "SecureKey")
        SecureKey_Label.stringValue = key!
        // Do view setup here.
    }
    
}
