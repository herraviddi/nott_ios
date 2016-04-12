//
//  DataService.swift
//  nott_ios
//
//  Created by Vidar Fridriksson on 30/03/16.
//  Copyright © 2016 hideout. All rights reserved.
//

import Foundation
//import Alamofire

class DataService{
    var UserObject = [String:AnyObject]()
    
    
    static let ds = DataService()
    
    
    private init(){
        self.UserObject = [String:AnyObject]()
    }
    
    func postIntake(userName:String,foodType:String,foodTitle:String,score:Int,grams:Int,picture:String,timeStamp:String){
        
        let parameters = [
            "user_name" :userName,
            "food_type" :foodType,
            "title" :foodTitle,
            "score" : score,
            "grams" : grams,
            "picture" : picture,
            "timestamp" : timeStamp
        ]
        
        
        
        let request = NSMutableURLRequest(URL: NSURL(string:"https://nott.herokuapp.com/food")!)
        
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        //Note : Add the corresponding "Content-Type" and "Accept" header. In this example I had used the application/json.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(parameters, options: [])
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard data != nil else {
                print("no data found: \(error)")
                return
            }
            
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    print("Response: \(json)")
                } else {
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)// No error thrown, but not NSDictionary
                    print("Error could not parse JSON: \(jsonStr)")
                }
            } catch let parseError {
                print(parseError)// Log the error thrown by `JSONObjectWithData`
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
            }
        }
        
        task.resume()

        
    }
}
