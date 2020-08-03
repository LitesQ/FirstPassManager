//
//  MainViewController.swift
//  FirstPassManager
//
//  Created by loka on 27.04.2020.
//  Copyright © 2020 loka. All rights reserved.
//

import Cocoa
import WebKit
import Foundation

var Values:NSArray = []

class TableCells: NSTableCellView {
    @IBOutlet weak var NameLabel: NSTextField!
    
}

class MainViewController: NSViewController,NSTableViewDataSource,NSTableViewDelegate {
    // глобальные переменные
    var ID = "";
    var name = "";
    var login = "";
    var pass = "";
    var site = "";
    var note = "";
    var SaveMode = "";
    var isDeleted = "";
    var TrashCan = "";
    
    
    
    // кнопки в левом меню
    @IBOutlet weak var UserButton: NSButton!
    @IBOutlet weak var UserNameLabel: NSTextField!
    @IBOutlet weak var AllElements: NSButton!
    @IBOutlet weak var AllElements_Box: NSBox!
    @IBOutlet weak var UserButtonBox: NSBox!
    @IBOutlet weak var AddElementBox: NSBox!
    @IBOutlet weak var TrashButtonBox: NSBox!
    
    // верхнее меню
    @IBOutlet weak var EditButton: NSButton!
    @IBOutlet weak var CancelButton: NSButton!
    @IBOutlet weak var SaveButton: NSButton!
    @IBOutlet weak var RestoreButton: NSButton!
    @IBOutlet weak var SearchField: NSSearchField!
    
    
    // Окно информации
    @IBOutlet weak var InfoLogo: NSImageView!
    @IBOutlet weak var InfoName: NSTextField!
    @IBOutlet weak var InfoLogin: NSTextField!
    @IBOutlet weak var InfoPassword: NSSecureTextField!
    @IBOutlet weak var InfoSite: NSTextField!
    @IBOutlet weak var InfoNote: NSTextView!
    @IBOutlet weak var InfoNoteField: NSScrollView!
    @IBOutlet weak var LoginLabel: NSTextField!
    @IBOutlet weak var PassLabel: NSTextField!
    @IBOutlet weak var SiteLabel: NSTextField!
    @IBOutlet weak var NoteLabel: NSTextField!
    @IBOutlet weak var DeleteButton: NSButton!
    @IBOutlet weak var NonSecurePasswordField: NSTextField!
    @IBOutlet weak var ShowPassword: NSButton!
    @IBOutlet weak var EditName: NSTextField!
    @IBOutlet weak var GeneratePass: NSButton!
    
    
    @IBAction func ShowPassword_Action(_ sender: Any) { // показать пароль
        if (NonSecurePasswordField.isHidden == true){
            NonSecurePasswordField.stringValue = InfoPassword.stringValue;
            NonSecurePasswordField.isHidden = false;
            InfoPassword.isHidden = true;
        }
        else {
            InfoPassword.stringValue = NonSecurePasswordField.stringValue;
            NonSecurePasswordField.isHidden = true;
            InfoPassword.isHidden = false;
        }
    }
    
    
    @IBAction func UserButton_Action(_ sender: Any) { // нажатие на кнопку пользователя
        AllElements_Box.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
        UserButtonBox.fillColor = #colorLiteral(red: 0, green: 0.9066776777, blue: 1, alpha: 0.5)
        AddElementBox.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
        TrashButtonBox.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
        
        let nextViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "UserProfileView")) as? NSViewController
        if let window = view.window{
            nextViewController?.view.frame = window.frame
        }
        
        presentViewController(nextViewController!, animator: ReplacePresentationAnimator())
        
        
    }
    
    @IBAction func AllElements_Action(_ sender: Any) { // нажатие на кнопку все элементы
        get(flag: true, trashflag: false, searchflag: false);
        AllElements_Box.fillColor = #colorLiteral(red: 0, green: 0.9066776777, blue: 1, alpha: 0.5)
        UserButtonBox.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
        AddElementBox.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
        TrashButtonBox.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
        TableView.isHidden = false;
        ClearRightMenu()
        TrashCan = "0"
    }
    @IBAction func AddElement_Action(_ sender: Any) {// нажатие на кнопку добавить элемент
        AllElements_Box.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
        UserButtonBox.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
        AddElementBox.fillColor = #colorLiteral(red: 0, green: 0.9066776777, blue: 1, alpha: 0.5)
        TrashButtonBox.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
        TableView.isHidden = true;
        ClearRightMenu()
        
        GeneratePass.isHidden = false;
        SaveButton.isHidden = false;
        EditName.isHidden = false;
        InfoLogin.isHidden = false;
        NonSecurePasswordField.isHidden = false;
        InfoSite.isHidden = false;
        InfoNoteField.isHidden = false;
        LoginLabel.isHidden = false;
        PassLabel.isHidden = false;
        SiteLabel.isHidden = false;
        NoteLabel.isHidden = false;
        InfoLogo.isHidden = false;
        
        InfoLogin.isEditable = true;
        NonSecurePasswordField.isEditable = true;
        InfoSite.isEditable = true;
        InfoNote.isEditable = true;
        
        SaveMode = "CreateNew"
        TrashCan = "0"
        
    }
    @IBAction func TrashButton_Action(_ sender: Any) {// нажатие на кнопку корзина
        AllElements_Box.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
        UserButtonBox.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
        AddElementBox.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
        TrashButtonBox.fillColor = #colorLiteral(red: 0, green: 0.9066776777, blue: 1, alpha: 0.5)
        TableView.isHidden = false;
        TrashCan = "1"
        
        get(flag: true, trashflag: true, searchflag: false)
    }
    
    @IBOutlet weak var TableView: NSTableView! // объявление таблицы
    
    
    func get(flag: Bool, trashflag: Bool, searchflag: Bool){ // получение данных из базы
        let Login = UserDefaults.standard.object(forKey: "Login").unsafelyUnwrapped as! String;

        var SearchRequest = ""
        
        if (searchflag == true){
            SearchRequest = SearchField.stringValue
        }
        
        
        var request = NSMutableURLRequest()
        
        if (trashflag == true && searchflag == false){
            request = NSMutableURLRequest(url: NSURL(string: "http://192.168.0.4/FirstPass/GetDataTrash.php")! as URL)
        }
        else if (trashflag == false && searchflag == true){
            request = NSMutableURLRequest(url: NSURL(string: "http://192.168.0.4/FirstPass/SearchData.php")! as URL)
        }
        else if (trashflag == true && searchflag == true){
            request = NSMutableURLRequest(url: NSURL(string: "http://192.168.0.4/FirstPass/SearchDataTrash.php")! as URL)
        }
        else{
            request = NSMutableURLRequest(url: NSURL(string: "http://192.168.0.4/FirstPass/GetData.php")! as URL)
        }
        
        request.httpMethod = "POST"
        
        var postString = ""
        
        if (searchflag == true){
            postString = "a=\(Login)&b=\(SearchRequest)"
        }
        else{
            postString = "a=\(Login)"
        }
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        var responseString: NSString = "";
        var errorFlag: Bool = false;
        var MyData: NSData = NSData()
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                errorFlag = true;
                return
            }
            MyData = NSData(data: data!)
            responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
        }
        task.priority = 1;
        task.resume()
    
        repeat{
            sleep(1/2)
        }while (responseString == "" && errorFlag == false)
        
        if (errorFlag != true){
            Values = try! JSONSerialization.jsonObject(with: MyData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
            
            if (flag == true){
                UserNameLabel.stringValue = Login as! String;
                TableView.reloadData()
            }
        } // Нужен обработчик ошибки подключения
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int { // количество элементов в таблице
        return Values.count;
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? { // ввод элементов в таблицу
        let maindata:[String: Any] = Values[row] as! [String : Any]

        if let cell = TableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier ("CellIdentifier"), owner: self) as? TableCells {

            let name = (maindata["Name"] as? String)!
            cell.NameLabel.stringValue = name;
            
            return cell
        }

        return nil
    }
    

    
    func tableViewSelectionDidChange(_ notification: Notification) { // выбор элементов из таблицы
        if (TableView.selectedRow) != -1 {
            let userdata:[String: Any] = Values[TableView.selectedRow] as! [String: Any]
            
            InfoName.stringValue = (userdata["Name"]) as! String;
            InfoLogin.stringValue = (userdata["Login"]) as! String;
            InfoPassword.stringValue = (userdata["Password"]) as! String;
            InfoSite.stringValue = (userdata["Website"]) as! String;
            InfoNote.string = (userdata["Note"]) as! String
            ID = (userdata["ID"]) as! String
            isDeleted = (userdata["isRemoved"]) as! String
            

            InfoLogo.isHidden = false;
            InfoName.isHidden = false;
            InfoLogin.isHidden = false;
            InfoPassword.isHidden = false;
            InfoSite.isHidden = false;
            InfoNoteField.isHidden = false;
            LoginLabel.isHidden = false;
            PassLabel.isHidden = false;
            SiteLabel.isHidden = false;
            NoteLabel.isHidden = false;
            ShowPassword.isHidden = false;

            GeneratePass.isHidden = true;
            if(isDeleted == "1"){
                EditButton.isHidden = true;
                RestoreButton.isHidden = false;
                DeleteButton.isHidden = false;
            }
            else{
                EditButton.isHidden = false;
                RestoreButton.isHidden = true;
                DeleteButton.isHidden = true;
            }
            CancelButton.isHidden = true;
            SaveButton.isHidden = true;
            ShowPassword.isHidden = false;
                
            NonSecurePasswordField.stringValue = "";
            NonSecurePasswordField.isHidden = true;


        }
        InfoName.isHidden = false;
        EditName.isHidden = true;
        InfoLogin.isEditable = false;
        NonSecurePasswordField.isEditable = false;
        NonSecurePasswordField.isHidden = true;
        InfoPassword.isHidden = false;
        InfoSite.isEditable = false;
        InfoNote.isEditable = false;
    }

    @IBAction func SearchField_Action(_ sender: Any) { // выполнение поиска
        if (TrashCan == "1"){
            get(flag: true, trashflag: true, searchflag: true)
        }
        else{
            get(flag: true, trashflag: false, searchflag: true)
        }
    }
    
    
    @IBAction func EditButton_Action(_ sender: Any) {// кнопка редактирования
        SaveMode = "Update";
        
        GeneratePass.isHidden = false;
        EditButton.isHidden = true;
        CancelButton.isHidden = false;
        SaveButton.isHidden = false;
        DeleteButton.isHidden = false;
        ShowPassword.isHidden = true;
        
        name = InfoName.stringValue;
        login = InfoLogin.stringValue;
        pass = InfoPassword.stringValue;
        site = InfoSite.stringValue;
        note = InfoNote.string;
        
        EditName.isHidden = false;
        InfoName.isHidden = true;
        EditName.stringValue = InfoName.stringValue;
        InfoLogin.isEditable = true;
        NonSecurePasswordField.isEditable = true;
        NonSecurePasswordField.isHidden = false;
        NonSecurePasswordField.stringValue = InfoPassword.stringValue;
        InfoPassword.isHidden = true;
        InfoSite.isEditable = true;
        InfoNote.isEditable = true;
        
        
    }
    @IBAction func CancelButton_Action(_ sender: Any) { // кнопка отмены
        EditButton.isHidden = false;
        CancelButton.isHidden = true;
        SaveButton.isHidden = true;
        DeleteButton.isHidden = true;
        ShowPassword.isHidden = false;
        
        GeneratePass.isHidden = true;
        InfoName.isHidden = false;
        EditName.isHidden = true;
        InfoLogin.isEditable = false;
        NonSecurePasswordField.isEditable = false;
        NonSecurePasswordField.isHidden = true;
        InfoPassword.isHidden = false;
        InfoSite.isEditable = false;
        InfoNote.isEditable = false;
        
        InfoName.stringValue = name;
        InfoLogin.stringValue = login;
        InfoPassword.stringValue = pass;
        InfoSite.stringValue = site;
        InfoNote.string = note;
    }
    
    @IBAction func SaveButton_Action(_ sender: Any) { // кнопка сохранить
        let Username = UserDefaults.standard.object(forKey: "Login").unsafelyUnwrapped;
        let Name = EditName.stringValue;
        let Login = InfoLogin.stringValue;
        let Password = NonSecurePasswordField.stringValue;
        let Site = InfoSite.stringValue;
        let Note = InfoNote.string;
        
        var request = NSMutableURLRequest()
        
        if (SaveMode == "CreateNew"){
            request = NSMutableURLRequest(url: NSURL(string: "http://192.168.0.4/FirstPass/SaveNewData.php")! as URL)
        }
        else if (SaveMode == "Update"){
            request = NSMutableURLRequest(url: NSURL(string: "http://192.168.0.4/FirstPass/AppendData.php")! as URL)
        }

        request.httpMethod = "POST"
        
        var postString = "";
        
        if (SaveMode == "CreateNew"){
            postString = "a=\(Username)&b=\(Name)&c=\(Login)&d=\(Password)&e=\(Site)&f=\(Note)"
        }
        else if (SaveMode == "Update"){
            postString = "a=\(Username)&b=\(Name)&c=\(Login)&d=\(Password)&e=\(Site)&f=\(Note)&g=\(ID)"
        }
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        var responseString: NSString = "";
        var errorFlag: Bool = false;
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                errorFlag = true;
                return
            }
            responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
        }
        task.priority = 1;
        task.resume()
        
        repeat{
            sleep(1/2)
        }while (responseString == "" && errorFlag == false)
        
        get(flag: true, trashflag: false,searchflag: false);
        
        InfoName.isHidden = false;
        EditName.isHidden = true;
        InfoLogin.isEditable = false;
        NonSecurePasswordField.isEditable = false;
        NonSecurePasswordField.isHidden = true;
        InfoPassword.isHidden = false;
        InfoSite.isEditable = false;
        InfoNote.isEditable = false;
        
        InfoName.stringValue = Name
        InfoLogin.stringValue = Login
        InfoPassword.stringValue = Password
        InfoSite.stringValue = Site
        InfoNote.string = Note
        
        GeneratePass.isHidden = true;
        EditButton.isHidden = false;
        CancelButton.isHidden = true;
        SaveButton.isHidden = true;
        DeleteButton.isHidden = true;
        ShowPassword.isHidden = false;
        
        NonSecurePasswordField.stringValue = "";
        NonSecurePasswordField.isHidden = true;
        
        if (SaveMode == "CreateNew"){
            TableView.isHidden = false;
            AllElements_Box.fillColor = #colorLiteral(red: 0, green: 0.9066776777, blue: 1, alpha: 0.5)
            UserButtonBox.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
            AddElementBox.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
            TrashButtonBox.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
            ID = responseString as String
        }
        SaveMode = "";
    }
    
    @IBAction func DeleteButton_Action(_ sender: Any) { // Кнопка удалить
        let Username = UserDefaults.standard.object(forKey: "Login").unsafelyUnwrapped;
        let Name = EditName.stringValue;
        let Login = InfoLogin.stringValue;
        let Password = NonSecurePasswordField.stringValue;
        let Site = InfoSite.stringValue;
        let Note = InfoNote.string;
        
        var request = NSMutableURLRequest()
        
        if (isDeleted == "0"){
            request = NSMutableURLRequest(url: NSURL(string: "http://192.168.0.4/FirstPass/MoveToTrash.php")! as URL)
        }
        else if (isDeleted == "1"){
            request = NSMutableURLRequest(url: NSURL(string: "http://192.168.0.4/FirstPass/DeleteData.php")! as URL)
        }
        
        request.httpMethod = "POST"
        
        var postString = "";
        
        if (isDeleted == "1"){
            postString = "a=\(ID)&b=\(Username)"
        }
        else if (isDeleted == "0"){
            postString = "a=\(Username)&b=\(Name)&c=\(Login)&d=\(Password)&e=\(Site)&f=\(Note)&g=\(ID)&h=\("1")"
        }
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        var responseString: NSString = "";
        var errorFlag: Bool = false;
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                errorFlag = true;
                return
            }
            responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
        }
        task.priority = 1;
        task.resume()
        
        repeat{
            sleep(1/2)
        }while (responseString == "" && errorFlag == false)
        
        if (isDeleted == "0"){
            get(flag: true, trashflag: false,searchflag: false);
        }
        else if (isDeleted == "1"){
            get(flag: true, trashflag: true,searchflag: false);
        }
        
        ClearRightMenu()
        
        if (isDeleted == "0"){
            TableView.isHidden = false;
            AllElements_Box.fillColor = #colorLiteral(red: 0, green: 0.9066776777, blue: 1, alpha: 0.5)
            UserButtonBox.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
            AddElementBox.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
            TrashButtonBox.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
            ID = responseString as String
        }
        isDeleted = "";
        
    }
    
    @IBAction func RestoreButton_Action(_ sender: Any) { // кнопка восстановить
        let Username = UserDefaults.standard.object(forKey: "Login").unsafelyUnwrapped;
        let Name = InfoName.stringValue;
        let Login = InfoLogin.stringValue;
        let Password = InfoPassword.stringValue;
        let Site = InfoSite.stringValue;
        let Note = InfoNote.string;

        let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.0.4/FirstPass/RestoreData.php")! as URL)

        request.httpMethod = "POST"
        
        let postString = "a=\(Username)&b=\(ID)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        var responseString: NSString = "";
        var errorFlag: Bool = false;
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                errorFlag = true;
                return
            }
            responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
        }
        task.priority = 1;
        task.resume()
        
        repeat{
            sleep(1/2)
        }while (responseString == "" && errorFlag == false)
        
        get(flag: true, trashflag: false,searchflag: false);
        
        AllElements_Box.fillColor = #colorLiteral(red: 0, green: 0.9066776777, blue: 1, alpha: 0.5)
        UserButtonBox.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
        AddElementBox.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
        TrashButtonBox.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.08607127568)
        
        InfoName.isHidden = false;
        EditName.isHidden = true;
        InfoLogin.isEditable = false;
        NonSecurePasswordField.isEditable = false;
        NonSecurePasswordField.isHidden = true;
        InfoPassword.isHidden = false;
        InfoSite.isEditable = false;
        InfoNote.isEditable = false;
        RestoreButton.isHidden = true;
        
        InfoName.stringValue = Name
        InfoLogin.stringValue = Login
        InfoPassword.stringValue = Password
        InfoSite.stringValue = Site
        InfoNote.string = Note
        
        GeneratePass.isHidden = true;
        EditButton.isHidden = false;
        CancelButton.isHidden = true;
        SaveButton.isHidden = true;
        DeleteButton.isHidden = true;
        ShowPassword.isHidden = false;
        
        NonSecurePasswordField.stringValue = "";
        NonSecurePasswordField.isHidden = true;
    }
    
    
    
    func ClearRightMenu() { // скрытие правой части
        InfoName.stringValue = "";
        InfoLogin.stringValue = "";
        InfoPassword.stringValue = "";
        NonSecurePasswordField.stringValue = "";
        InfoSite.stringValue = "";
        InfoNote.string = "";
        EditName.stringValue = "";
        
        RestoreButton.isHidden = true;
        GeneratePass.isHidden = true;
        InfoLogo.isHidden = true;
        InfoName.isHidden = true;
        InfoLogin.isHidden = true;
        InfoPassword.isHidden = true;
        InfoSite.isHidden = true;
        InfoNoteField.isHidden = true;
        LoginLabel.isHidden = true;
        PassLabel.isHidden = true;
        SiteLabel.isHidden = true;
        NoteLabel.isHidden = true;
        EditButton.isHidden = true;
        ShowPassword.isHidden = true;
        CancelButton.isHidden = true;
        SaveButton.isHidden = true;
        DeleteButton.isHidden = true;
        EditName.isHidden = true;
        NonSecurePasswordField.isHidden = true;
    }
    
    @IBAction func GeneratePass_Action(_ sender: Any) {
        NonSecurePasswordField.stringValue = randomString(length: 25)
    }
    
    func randomString(length: Int) -> String {
        

        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+}{[]"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    override func viewDidLoad() {// загрузка формы
        super.viewDidLoad()

        if (UserDefaults.standard.object(forKey: "Login") != nil && UserDefaults.standard.object(forKey: "Password") != nil && UserDefaults.standard.object(forKey: "SecureKey") != nil){// когда в дефолтах есть информация юзера
            get(flag: true, trashflag: false,searchflag: false)
            SearchField.isEnabled = true
        }

        TableView.dataSource = self
        TableView.delegate = self
    }
    
    override func viewDidAppear() {// появление формы
        if (UserDefaults.standard.object(forKey: "Login") == nil || UserDefaults.standard.object(forKey: "Password") == nil || UserDefaults.standard.object(forKey: "SecureKey") == nil){ // переход в авторизацию если дефолты пустые
            let nextViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "AuthentificationViewController")) as? NSViewController
            if let window = view.window{
                nextViewController?.view.frame = window.frame
            }
            presentViewController(nextViewController!, animator: ReplacePresentationAnimator())
        }
    }
    
}
