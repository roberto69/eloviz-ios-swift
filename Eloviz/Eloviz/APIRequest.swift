//
//  APIRequest.swift
//  Eloviz
//
//  Created by guillaume labbe on 04/01/16.
//  Copyright © 2016 guillaume labbe. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MagicalRecord

public class APIRequest: NSObject{
    
    var apiHost: String = "https://api.eloviz.com"

    func createUser(name : String, password: String, mail: String, userPage: LoginPageView) {
        let parametersJSON = ["username" : name,
                            "email" : mail,
                            "password" : password]
        
        var success = false
        
        Alamofire.request(.POST, apiHost + "/users", parameters : parametersJSON, encoding: .JSON)
            .responseJSON { response in
                success = response.result.isSuccess

                if success {
                    var user = User.MR_findFirst()
                    
                    if (success) {
                        if (user == nil) {
                            user = User.MR_createEntity();
                        }
                        user.name = name
                        user.password = password
                        user.mail = mail
                    
                        self.createToken(mail, password: password, user: user, userPage: userPage)
                    }
                } else {
                    // handle error
                }
        }
    }
    
    func createToken(mail: String, password: String, user: User, userPage: LoginPageView) {
        let parametersJSON = ["username" : mail,
                            "password" : password,
                            "grant_type" : "password"]
        
        Alamofire.request(.POST, apiHost + "/oauth/access_token", parameters: parametersJSON, encoding: .JSON)
            .responseJSON { response in
            
                if response.result.isSuccess {
                    if let value: AnyObject = response.result.value {
                        let post = JSON(value)
                        if let refresh_token = post["refresh_token"].string,
                            let access_token = post["access_token"].string {
                                user.refreshToken = refresh_token
                                user.oauth = access_token
                                
                                NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                                userPage.refresh(true)
                        }
                    }
                } else {
                    userPage.refresh(false)
                }
        }
    }
    
    func getMe(token: String, home: ViewController) {
        let header = ["Authorization" : "Bearer " + token]
        
        Alamofire.request(.GET, apiHost + "/me", headers: header)
                 .responseJSON { response in
                    home.displayRoom(response.result.isSuccess)
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstLaunch")
        }
    }
    
    func getStreams(currentView: DiscoverStreamsView) {
        Alamofire.request(.GET, apiHost + "/streams")
        .responseJSON { response in
            if response.result.isSuccess {
                let streams = NSMutableDictionary()
                
                if let value: AnyObject = response.result.value {
                    let get = JSON(value)
                    for var i = 0; i < get.count; i++ {
                        let values = get[i]
                        let participants = values["participants"].description
                        let title = values["title"].description
                        let description = values["description"].description
                        
                        streams.setValue(["participants" : participants, "title" : title, "description" : description], forKey: String(i))
                    }
                    currentView.setStreamsList(streams)
                }
            } else {
            }
        }
    }
    
    func joinRoom(roomName: String, password: String) {
        let parametersJSON = ["title" : roomName,
                                "password" : password]
        
        Alamofire.request(.GET, apiHost + "/streams/join", parameters : parametersJSON, encoding: .JSON)
            .responseJSON { response in
                print(response)
        }
    }
}