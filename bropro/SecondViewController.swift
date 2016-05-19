//
//  SecondViewController.swift
//  bropro
//
//  Created by Amy Giver on 5/17/16.
//  Copyright © 2016 Amy Giver. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var caloriesLabel: UILabel!
    
    var pickerDataSource = ["Cycling", "Stationary cycling", "Calisthenics", "Weight lifting", "Rowing Machine", "Aerobics", "Water aerobics", "Dancing", "Running", "Basketball", "Boxing", "Football", "Frisbee", "Golf", "Ice Hockey", "Horseback Riding", "Martial Arts", "Kickball", "Lacrosse", "Racquetball", "Rock Climbing", "Rugby", "Skateboarding/ Roller Skating", "Soccer", "Baseball, Softball", "Tennis", "Volleyball", "Wrestling", "Hiking", "Walking", "Whitewater", "Sailing, yachting, ocean sailing", "Skin Diving", "Surfing, body surfing or board surfing", "Swimming", "Water Sports (Pool)", "Ice Skating", "Cross Country Skiing", "Downhill Skiing"]
    
    var pickerDataSourceActivity = ["30 Minutes","1 Hour","1.5 Hour","2 Hours","2.5 Hours","3 Hours","3.5 Hours","4 Hours","4.5 Hours","5 Hours","5.5 Hours","6 Hours","6.5 Hours","7 Hours","7.5 Hours","8 Hours","8.5 Hours","9 Hours","9.5 Hours","10 Hours","10.5 Hours","11 Hours","11.5 Hours","12 Hours"]
    var col = "column"
    var duration = Float(0)
    var swoleinducer = "swole"
    var burn = Float(0)
    
    @IBOutlet weak var swoleText: UITextField!
    
    
    @IBOutlet weak var burnTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
//        get_all_activities()
        pickerView.dataSource = self
        pickerView.delegate = self
        swoleText.inputView = pickerView
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     @IBOutlet weak var pickerView: UIPickerView!
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        return pickerDataSource[row]
        print (pickerDataSource[row])
    }
    
    func pickerView(pickerView:UIPickerView, didSelectRow row:Int, inComponent component: Int){
        swoleText.text = pickerDataSource[row]
        
    }
  

    //activity duration input
    @IBOutlet weak var timeSpent: UISlider!
    @IBOutlet weak var timeSpentLabel: UILabel!
    
    @IBAction func timeSlider(sender: UISlider) {
        duration = round(Float(sender.value)*10)/10
        timeSpentLabel.text="\(duration)"
    }

    //posting data functions
    @IBAction func intensityPressed(sender: UIButton) {
        print("button pressed")
        swoleinducer = swoleText.text!
        print("HIIIIIII", swoleinducer)

        let user_id = NSUserDefaults.standardUserDefaults().stringForKey("userID")
        let weight = NSUserDefaults.standardUserDefaults().stringForKey("weight")
        let age = NSUserDefaults.standardUserDefaults().stringForKey("age")
        let height = NSUserDefaults.standardUserDefaults().stringForKey("height")
        let gender = NSUserDefaults.standardUserDefaults().stringForKey("gender")
        if Int(weight!) < 145 {
            col = "cals_at_130"
        }
        else if Int(weight!) < 165 && Int(weight!) >= 145 {
            col = "cals_at_155"
        }
        else if Int(weight!) < 195 && Int(weight!) >= 165 {
            col = "cals_at_180"
        }
        else {
           col = "cals_at_205"
        }
        
        
        let myUrl = NSURL(string: "http://localhost:3000/swolcontrols/add_workout")
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "POST"
        var intensity_id: String
        
        print("postsetup")
        
        if sender.tag == 1 {
            intensity_id = "light"
        }
        else if sender.tag == 2 {
            intensity_id = "medium"
        }
        else if sender.tag == 3 {
            intensity_id = "hard"
        }
        else {
            intensity_id = "light"
        }
        
        
        NSUserDefaults.standardUserDefaults().setObject(intensity_id, forKey:"intensity")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let postString = "intensity=\(intensity_id)&user_id=\(user_id!)&activity=\(swoleinducer)&duration=\(duration)&weight=\(weight!)&height=\(height!)&gender=\(gender!)&age=\(age!)&column=\(col)"
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
                    
                   
                        print("it's gonna happen", jsonResult)
                        
                        if(String(jsonResult["calories"]!["activity"]!!) == "Water aerobics"){
                                print ("water aerobics spotted")
                                var shamealert = UIAlertController(title: "Alert", message: "Water aerobics? You are no bro", preferredStyle: UIAlertControllerStyle.Alert)
                            
                                let deleteAction = UIAlertAction(title: "Delete my account", style: UIAlertActionStyle.Default){ action in
                                
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
                                
//                                NSUserDefaults.standardUserDefaults().synchronize()
                                self.performSegueWithIdentifier("loginView", sender: self)
                                }
                            
                            shamealert.addAction(deleteAction)
                            self.presentViewController(shamealert, animated:true, completion:nil)

                            }
                    
                        else {
                    dispatch_async(dispatch_get_main_queue(), {

                    

                        let calories = String(jsonResult["calories"]![self.col]!!)
                        let time = String(self.duration)
                        let burn = Float(calories)! * (self.duration)
                        print(burn)
                        self.burnTextField.text! = String(burn)
                        print("firstburn", burn)
                        

                    })
                }
                }
                
            }
                
            catch {
                print(error)
            }
            
        }
        task.resume()
        if swoleText.text != "Water aerobics" {
        
        
        
        var alert = UIAlertController(title: "Alert", message: "Is that all you got?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Yeah bro", style: UIAlertActionStyle.Default){ action in
            print("okay")
            self.add_workout()
        }
        
        alert.addAction(okAction)
        self.presentViewController(alert, animated:true, completion:nil)

        }
    }
    
    func add_workout(){
        let user_id = NSUserDefaults.standardUserDefaults().stringForKey("userID")
        let weight = NSUserDefaults.standardUserDefaults().stringForKey("weight")
        let age = NSUserDefaults.standardUserDefaults().stringForKey("age")
        let height = NSUserDefaults.standardUserDefaults().stringForKey("height")
        let gender = NSUserDefaults.standardUserDefaults().stringForKey("gender")
        let intensity = NSUserDefaults.standardUserDefaults().stringForKey("intensity")
        let myUrl2 = NSURL(string: "http://localhost:3000/swolcontrols/add_workout_foreal")
        let request2 = NSMutableURLRequest(URL:myUrl2!)
        request2.HTTPMethod = "POST"
        let totalburn = self.burnTextField.text!
        print("*************",totalburn)
        
        let postString2 = "intensity=\(intensity!)&user_id=\(user_id!)&activity=\(self.swoleinducer)&weight=\(weight!)&height=\(height!)&gender=\(gender!)&age=\(age!)&column=\(self.col)&burn=\(totalburn)"
        
        request2.HTTPBody = postString2.dataUsingEncoding(NSUTF8StringEncoding)
        print("poststring2", postString2)
        
        let task2 = NSURLSession.sharedSession().dataTaskWithRequest(request2) {
            
            data, response, error in
            if error != nil {
                print("error = \(error)")
                return
            }
            var err: NSError?
            do {
                if let jsonResult2 = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary {
//                    dispatch_async(dispatch_get_main_queue(), {
                    
                        print("Surprise json", jsonResult2)
                    
                    let burnedcals = jsonResult2["calinfo"]!["calories"]
                    print(burnedcals)
                    
                    NSUserDefaults.standardUserDefaults().setObject(burnedcals, forKey:"burnedcals")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    
                    dispatch_async(dispatch_get_main_queue(), {

                    self.caloriesLabel.text = String(burnedcals!!)
                    })
                   
        
                        
                        //these bracket below closes dispatch
//                    })
                    //this bracket below closes if let jsonResult
                }
                //this bracket below closes do
            }
                
            catch {
                print(error)
            }
            
            
            //this bracket below closes let task2
        }
        
        task2.resume()
        

    }
    
    override func viewDidAppear(animated: Bool) {
        let user_id = NSUserDefaults.standardUserDefaults().stringForKey("userID")
        
        let myUrl = NSURL(string: "http://localhost:3000/swolcontrols/todays_burn")
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "POST"
        
        let postString = "user_id=\(user_id!)"
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
                        if String(jsonResult["calories"]!["calories"]!!) == "<null>"{
                            self.caloriesLabel.text = "0"
                        }
                        else {
                            self.caloriesLabel.text = String(jsonResult["calories"]!["calories"]!!)
                        }
                    })
                    
                }
                
            }
                
            catch {
                print(error)
            }
            
        }
        task.resume()
        
    

        
    }
    
    
    
//    func get_all_activities(){
//        let url = NSURL(string: "http://localhost:3000/swolcontrols/get_activity_list")
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithURL(url!, completionHandler: {
//            data, response, error in
//            do {
//
//                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
//
//                    let activities = jsonResult["activities"]!
//                    for activity in activities as! [AnyObject] {
//                        self.pickerDataSource.append(String(activity["activity"]!!))
//                    }
//        
//                }
//            } catch {
//                print("Something went wrong")
//            }
//        })
//        task.resume()
//        pickerView.reloadAllComponents()
//        
//           }
//
    
    
    }
