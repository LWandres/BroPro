//
//  LoginViewController.swift
//  bropro
//
//  Created by Amy Giver on 5/17/16.
//  Copyright © 2016 Amy Giver. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var userEmailTextField: UITextField!
    
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        let userPassword = userPasswordTextField.text
        let userEmail = userEmailTextField.text
        let myURL = NSURL(string: "http://localhost:3000/tasks/get_bro_by_email")
        let request = NSMutableURLRequest(URL:myURL!)
        request.HTTPMethod = "POST"
        let postString = "email=\(userEmail!)&password=\(userPassword!)"
        print("text fields", postString)
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if error != nil {
                print("error = \(error)")
                return
            }
            var err: NSError?
            do {
                print("do statement")
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary {
                    
                    print("after login button", jsonResult)
                    
                    
                    dispatch_async(dispatch_get_main_queue(), {
                    
                    if (jsonResult["bro"] != nil) {
                        print("just id", jsonResult["bro"]!["id"]!!)
                        
                        NSUserDefaults.standardUserDefaults().setObject(jsonResult["bro"]!["id"]!!, forKey:"userID")
                        NSUserDefaults.standardUserDefaults().setObject(jsonResult["bro"]!["user_email"]!!, forKey:"userEmail")
                        NSUserDefaults.standardUserDefaults().setObject(jsonResult["bro"]!["user_password"]!!, forKey:"userPassword")
                         NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
                        NSUserDefaults.standardUserDefaults().setObject(jsonResult["bro"]!["age"]!!, forKey:"age")
                        NSUserDefaults.standardUserDefaults().setObject(jsonResult["bro"]!["gender"]!!, forKey:"gender")
                        NSUserDefaults.standardUserDefaults().setObject(jsonResult["bro"]!["height"]!!, forKey:"height")
                        NSUserDefaults.standardUserDefaults().setObject(jsonResult["bro"]!["weight"]!!, forKey:"weight")
                        NSUserDefaults.standardUserDefaults().setObject(jsonResult["bro"]!["bmr"]!!, forKey:"bmr")
                         NSUserDefaults.standardUserDefaults().synchronize()
                        print("Logging in", NSUserDefaults.standardUserDefaults().dictionaryRepresentation(), "done logging in")
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                        }
                        else {
                        var alert = UIAlertController(title: "Alert", message: "Bro, you're not in our database, you gotta register", preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
                            self.performSegueWithIdentifier("registerView", sender: self)
                        }
                        alert.addAction(okAction)
                        self.presentViewController(alert, animated:true, completion:nil)
                        }
                    })
                    
                    
                    
                    
                }

            }
            catch
            { print(error)}
        }
        task.resume()
//        get_all_bros()
        
                    
                    
//                    if let newid = jsonResult["id"] {
//                        
//                        NSUserDefaults.standardUserDefaults().setObject(newid, forKey:"userID")
//                        NSUserDefaults.standardUserDefaults().setObject(userEmail, forKey:"userEmail")
//                        NSUserDefaults.standardUserDefaults().setObject(userPassword, forKey:"userPassword")
//                        NSUserDefaults.standardUserDefaults().synchronize()
//                        
                    
                        


        
        
//        
//        let userEmailStored = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")
//        let userPasswordStored = NSUserDefaults.standardUserDefaults().stringForKey("userPassword")
//        if userEmailStored == userEmail && userPasswordStored == userPassword {
//            //login is successful
//            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
//            NSUserDefaults.standardUserDefaults().synchronize()
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
//        else {
//            //display alert that login failed
//            print("Login failed")
//        }
//        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        get_all_bros()
//        let url = NSURL(string: "http://localhost:3000/tasks/get_all_bros")
//                let session = NSURLSession.sharedSession()
//                let task = session.dataTaskWithURL(url!, completionHandler: {
//                    data, response, error in
//                    do {
//        
//                        if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSArray {
//                            print("all", jsonResult)
//                                            }
//                    } catch {
//                        print("Something went wrong")
//                    }
//                    })
//                task.resume()
    }
    
    func get_all_bros(){
        let url = NSURL(string: "http://localhost:3000/tasks/get_all_bros")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {
            data, response, error in
            do {
                
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSArray {
                    print("all", jsonResult)
                }
            } catch {
                print("Something went wrong")
            }
        })
        task.resume()
        print("user defaults", NSUserDefaults.standardUserDefaults().dictionaryRepresentation())
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
        if isUserLoggedIn {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

 



}