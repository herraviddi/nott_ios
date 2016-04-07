//
//  DataService.swift
//  nott_ios
//
//  Created by Vidar Fridriksson on 30/03/16.
//  Copyright © 2016 hideout. All rights reserved.
//

import Foundation

class DataService{
    var UserObject = [String:AnyObject]()
    
    
    static let ds = DataService()
    
    
    private init(){
        self.UserObject = [String:AnyObject]()
    }
    
//    func postIntake(userName:String,foodType:String,foodTitle:String,score:Int,grams:Int,picture:NSData,timeStamp:NSDate){
//        
//        
//        let postURL = "https://nott.herokuapp.com/food"
//        
//        let data = [
//            "user_name" :userName,
//            "food_type" :foodType,
//            "title" :foodTitle,
//            "score" : score,
//            "grams" : grams,
//            "picture" : picture,
//            "timestamp" : timeStamp
//        ]
//        Alamofire.request(.POST, postURL, parameters: (data as! [String : AnyObject]), encoding: .JSON)
//            .responseJSON { response in
//                print(response.response)
//                print(response.result)
//                if response.result.isSuccess {
//                    if response.response?.statusCode == 400{
//                        print("error 400")
//                        messageSendSuccess = false
//                    }else{
//                        messageSendSuccess = true
//                    }
//                }else{
//                    print("error in sendemail dataservice")
//                    messageSendSuccess = false
//                }
//        }
//    }
}
