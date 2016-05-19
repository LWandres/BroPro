//
//  ProfileViewController.swift
//  bropro
//
//  Created by Amy Giver on 5/19/16.
//  Copyright © 2016 Amy Giver. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var ageLabel: UITextField!
    @IBOutlet weak var weightLabel: UITextField!
    @IBOutlet weak var genderLabel: UITextField!
    @IBOutlet weak var heightLabel: UITextField!
    
    @IBOutlet weak var bmrLabelField: UILabel!
    
    override func viewDidAppear(animated: Bool) {
//        super.viewDidLoad()
            let user_id = NSUserDefaults.standardUserDefaults().stringForKey("userID")
            let weight = NSUserDefaults.standardUserDefaults().stringForKey("weight")
            let age = NSUserDefaults.standardUserDefaults().stringForKey("age")
            let height = NSUserDefaults.standardUserDefaults().stringForKey("height")
            let gender = NSUserDefaults.standardUserDefaults().stringForKey("gender")
            let password = NSUserDefaults.standardUserDefaults().stringForKey("userPassword")
            let email = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")
            let bmr = NSUserDefaults.standardUserDefaults().stringForKey("bmr")
        
            emailLabel.text = email
            passwordLabel.text = password
            ageLabel.text = age
            weightLabel.text = weight
            genderLabel.text = gender
            heightLabel.text = height
            bmrLabelField.text = bmr
//            print(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())
        
        
    }
    
    @IBAction func updateButtonPressed(sender: AnyObject) {
        let userEmail = emailLabel.text
        let userPassword = passwordLabel.text
        let height = heightLabel.text
        let weight = weightLabel.text
        let gender =  genderLabel.text
        let age = ageLabel.text
        let user_id = NSUserDefaults.standardUserDefaults().stringForKey("userID")
        
        //send user data to server side
        
        let myUrl = NSURL(string: "http://52.36.8.146/tasks/update_profile")
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "POST"
        
        let postString = "email=\(userEmail!)&user_id=\(user_id!)&password=\(userPassword!)&height=\(height!)&weight=\(weight!)&gender=\(gender!)&age=\(age!)"
        print("poststring", postString)
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {

            data, response, error in
            if error != nil {
                print("error = \(error)")
                return
            }
            var err: NSError?

            do {
                print("made it")
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary {
                    print("after update button", jsonResult)
                    
                    if jsonResult.count >= 1 {
//                        let bmr = jsonResult["oneuser"]!["bmr"]//change this later to reflect bmr changes with age/weight

                        NSUserDefaults.standardUserDefaults().setObject(userEmail, forKey:"userEmail")
                        NSUserDefaults.standardUserDefaults().setObject(userPassword, forKey:"userPassword")
                        NSUserDefaults.standardUserDefaults().setObject(weight, forKey:"weight")
                        NSUserDefaults.standardUserDefaults().setObject(age, forKey:"age")
                        NSUserDefaults.standardUserDefaults().setObject(height, forKey:"height")
                        NSUserDefaults.standardUserDefaults().setObject(gender, forKey:"gender")
//                        NSUserDefaults.standardUserDefaults().setObject(bmr, forKey:"bmr")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        print(NSUserDefaults.standardUserDefaults().stringForKey("userID"))
                        if jsonResult["message"] != nil{
                        dispatch_async(dispatch_get_main_queue(), {
                            var alert = UIAlertController(title:"Success!", message: "Your Brofile is now up to date", preferredStyle: UIAlertControllerStyle.Alert)
                            let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default) {action in
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                            alert.addAction(okAction)
                            self.presentViewController(alert, animated:true, completion:nil)
                        })
                        }
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
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
        
        
    }
    
    

//}

