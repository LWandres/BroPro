//
//  FirstViewController.swift
//  bropro
//
//  Created by Amy Giver on 5/17/16.
//  Copyright © 2016 Amy Giver. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var caloriesLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user_id = NSUserDefaults.standardUserDefaults().stringForKey("userID")
        
        let myUrl = NSURL(string: "http://localhost:3000/brofoods/todays_calories")
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "POST"
        
        let postString = "user_id=\(user_id)"
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
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        print(jsonResult)
                        if String(jsonResult["foodcals"]!["calories"]!!) == "<null>" {
                            self.caloriesLabel.text = "0"
                            print("nullLLLLllllll")
                        }
                        else {
                            print(String(jsonResult["foodcals"]!["calories"]))
                        self.caloriesLabel.text = String(jsonResult["foodcals"]!["calories"]!!)
                        }
                    })
                    
                }
                
            }
                
            catch {
                print(error)
            }
            
        }
        task.resume()
        
                
                    
        
        
        
        
//        print(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let user_id = NSUserDefaults.standardUserDefaults().stringForKey("userID")
        if user_id == nil {
            self.performSegueWithIdentifier("loginView", sender: self)
        }
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
        if !isUserLoggedIn {
            self.performSegueWithIdentifier("loginView", sender: self)
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }


    @IBAction func logoutButtonTapped(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey:"isUserLoggedIn")
        NSUserDefaults.standardUserDefaults().setObject("", forKey:"userID")
        NSUserDefaults.standardUserDefaults().setObject("", forKey:"userEmail")
        NSUserDefaults.standardUserDefaults().setObject("", forKey:"userPassword")
        NSUserDefaults.standardUserDefaults().setObject("", forKey:"weight")
        NSUserDefaults.standardUserDefaults().setObject("", forKey:"age")
        NSUserDefaults.standardUserDefaults().setObject("", forKey:"height")
        NSUserDefaults.standardUserDefaults().setObject("", forKey:"gender")
        NSUserDefaults.standardUserDefaults().setObject("", forKey:"intensity")
        NSUserDefaults.standardUserDefaults().setObject("", forKey:"burnedcals")

        NSUserDefaults.standardUserDefaults().synchronize()
        self.performSegueWithIdentifier("loginView", sender: self)
        print(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())
        
    }
    
    
    @IBAction func chickenEaten(sender: UIButton) {
        print("chicken time")
        
        
        
        let user_id = NSUserDefaults.standardUserDefaults().stringForKey("userID")
        let myUrl = NSURL(string: "http://52.36.8.146/brofoods/add_meal")
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "POST"
        var food_id:Int
        if sender.tag == 1 {
            food_id = 199
        }
        else if sender.tag == 2 {
            food_id = 767
        }
        else if sender.tag == 3 {
            food_id = 312
        }
        else if sender.tag == 4 {
            food_id = 961
        }
        else if sender.tag == 5 {
            food_id = 77
        }
        else if sender.tag == 6 {
            food_id = 935
        }
        else if sender.tag == 7 {
            food_id = 391
        }
        else if sender.tag == 8 {
            food_id = 226
        }
        else if sender.tag == 9 {
            food_id = 110
        }
        else if sender.tag == 10 {
            food_id = 404
        }
        else if sender.tag == 11 {
            food_id = 687
        }
        else if sender.tag == 12 {
            food_id = 69
        }
        else {
            food_id = 1000
        }
        let postString = "food_id=\(food_id)&user_id=\(user_id!)"
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
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary {
                    
                    dispatch_async(dispatch_get_main_queue(), {

                    
                    print("hello world")
                    print("after chicken button", jsonResult)
                    self.caloriesLabel.text = String(jsonResult["calories"]!["calories"]!!)
                    print(jsonResult["calories"]!["calories"]!!)
                        
                    })
                }
               
                        
            }
            
            catch {
                print(error)
            }
            
        }
        task.resume()
        
        
        
        

        
        
        
    }
    
    
    
    
}

