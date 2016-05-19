//
//  RegistrationViewController.swift
//  bropro
//
//  Created by Amy Giver on 5/17/16.
//  Copyright © 2016 Amy Giver. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    var bros: [String] = ["John"]
    
    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var userConfirmPasswordTextField: UITextField!
    
    @IBOutlet weak var userHeight: UITextField!
    
    @IBOutlet weak var userAge: UITextField!
    
    @IBOutlet weak var userGender: UITextField!
    
    @IBOutlet weak var userWeight: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let url = NSURL(string: "http://localhost:3000/tasks/get_all_bros")
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithURL(url!, completionHandler: {
//            data, response, error in
//            do {
//                
//                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSArray {
//                                    }
//            } catch {
//                print("Something went wrong")
//            }
//            })
//        task.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(sender: UIButton) {
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let userConfirmPassword = userConfirmPasswordTextField.text
        let height = userHeight.text
        let weight = userWeight.text
        let gender = userGender.text
        let age = userAge.text
        
        
        
        //check for empty fields
        if userEmail!.isEmpty || userPassword!.isEmpty || userConfirmPassword!.isEmpty || height!.isEmpty || weight!.isEmpty || gender!.isEmpty || age!.isEmpty {
            
            displayAlertMessage("All fields are required")
            return
        }
        //check that passwords match
        if userPassword! != userConfirmPassword! {
            displayAlertMessage("Passwords do not match")
            return
        }
        
        //send user data to server side
        
        let myUrl = NSURL(string: "http://52.36.8.146/tasks/add_user")
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "POST"
        let postString = "email=\(userEmail!)&password=\(userPassword!)&height=\(height!)&weight=\(weight!)&gender=\(gender!)&age=\(age!)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
        
        data, response, error in
            if error != nil {
                print("error = \(error)")
                return
            }
            var err: NSError?
            
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary {
                    print("after reg button", jsonResult)
//                    var x = true
//                    
//                   if x == true {
//
                    if let userid = jsonResult["newid"] {
                        let bmr = jsonResult["oneuser"]!["bmr"]
                        NSUserDefaults.standardUserDefaults().setObject(userid, forKey:"userID")
                        NSUserDefaults.standardUserDefaults().setObject(userEmail, forKey:"userEmail")
                        NSUserDefaults.standardUserDefaults().setObject(userPassword, forKey:"userPassword")
                        NSUserDefaults.standardUserDefaults().setObject(true, forKey:"isUserLoggedIn")
                        NSUserDefaults.standardUserDefaults().setObject(weight, forKey:"weight")
                        NSUserDefaults.standardUserDefaults().setObject(age, forKey:"age")
                        NSUserDefaults.standardUserDefaults().setObject(height, forKey:"height")
                        NSUserDefaults.standardUserDefaults().setObject(gender, forKey:"gender")
                        NSUserDefaults.standardUserDefaults().setObject(bmr, forKey:"bmr")
                        NSUserDefaults.standardUserDefaults().synchronize()
                    print(NSUserDefaults.standardUserDefaults().stringForKey("userID"))
//                        print("user defaults", NSUserDefaults.standardUserDefaults().dictionaryRepresentation())
//                        
                       
                        dispatch_async(dispatch_get_main_queue(), {
                            
                        var alert = UIAlertController(title:"Alert", message: "Registration successful! Thanks, bro!", preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default) {action in
                            self.dismissViewControllerAnimated(true, completion: nil)
                            }
                            alert.addAction(okAction)
                            self.presentViewController(alert, animated:true, completion:nil)
                            })
                    
                    }
                
           
                }
            }
            catch {
            print(error)
            }
            
            }
        task.resume()

     
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
        userEmailTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func backToLogin(sender: UIButton) {
        dismissViewControllerAnimated(true, completion:nil)
    }

    func displayAlertMessage(userMessage:String) {
        var alert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated:true, completion:nil)
    }

    
}