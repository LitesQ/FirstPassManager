//
//  NewSecureKey.swift
//  FirstPassManager
//
//  Created by loka on 06.05.2020.
//  Copyright © 2020 loka. All rights reserved.
//

import Cocoa

class NewSecureKey: NSViewController {
    
    @IBOutlet weak var NewSecureKeyLabel: NSTextField!
    
    @IBAction func Finish_Action(_ sender: Any) {
        dismiss(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let Key = UserDefaults.standard.object(forKey: "SecureKey").unsafelyUnwrapped
        NewSecureKeyLabel.stringValue = Key as! String
        // Do view setup here.
    }
}
