//
//  bropromodel.swift
//  bropro
//
//  Created by Amy Giver on 5/17/16.
//  Copyright © 2016 Amy Giver. All rights reserved.
//

import Foundation
class bropromodel {
    static func getAllBros(completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        let url = NSURL(string: "http://localhost:3000/tasks/get_all_bros")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: completionHandler)
        task.resume()
        }
    
    static func add_user_email (completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
            let url = NSURL(string: "http://localhost:3000/tasks/add_user_email")
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url!, completionHandler: completionHandler)
            task.resume()
        }
        
    }

