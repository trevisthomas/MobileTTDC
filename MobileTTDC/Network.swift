//
//  Network.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 5/30/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit
import Foundation

public struct Network {
    
    private static func getToken() -> String? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.applicationContext.token
    }
    
    private static func getHost()-> String{
        return "http://ttdc.us:8888"
//        return "http://ttdc.us"
//        return "https://ttdc.us"

    }
    
    public static func performLogin(command : LoginCommand, completion: (response : LoginResponse?, error: String?) -> Void){
        NetworkAdapter.performCommand("\(getHost())/restful/login", command: command, completion: completion)
    }
    
    public static func performPostCommand(command : PostCommand, completion: (response : PostResponse?, error: String?) -> Void){
        command.token = getToken()
        NetworkAdapter.performCommand("\(getHost())/restful/latestposts", command: command, completion: completion)
    }
    
    public static func performSearchCommand(command : SearchCommand, completion: (response : SearchResponse?, error: String?) -> Void){
//        NetworkAdapter.performCommand("https://ttdc.us/restful/latestConversations", command: command, completion: completion)
        command.token = getToken()
        NetworkAdapter.performCommand("\(getHost())/restful/latestConversations", command: command, completion: completion)
    }
    
    public static func performPostCommand(command : TopicCommand, completion: (response : TopicResponse?, error: String?) -> Void){
        command.token = getToken()
        NetworkAdapter.performCommand("\(getHost())/restful/topic", command: command, completion: completion)
    }
    
    public static func performAutocompleteCommand(command : AutoCompleteCommand, completion: (response : AutoCompleteResponse?, error: String?) -> Void){
        command.token = getToken()
        NetworkAdapter.performCommand("\(getHost())/restful/autocomplete", command: command, completion: completion)
    }
    
    public static func performPostCrudCommand(command: PostCrudCommand, completion: (response: PostCrudResponse?, error: String?)->Void){
        command.token = getToken()
        NetworkAdapter.performCommand("\(getHost())/restful/post", command: command, completion: completion)
    }
    
    public static func performRegisterForPushCommand(command: RegisterCommand, completion: (response: RegisterResponse?, error: String?)->Void){
        command.token = getToken()
        NetworkAdapter.performCommand("\(getHost())/restful/register", command: command, completion: completion)
    }
    
}