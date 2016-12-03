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
    
    fileprivate static func getToken() -> String? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.applicationContext.token
    }
    
    public static func getUnsecuredHost()->String{
        return "http://ttdc.us"
    }
    
    public static func getHost()-> String{
        return "http://ttdc.us:8888"
//        return "http://ttdc.us"
//        return "https://ttdc.us"
//        return "http://192.168.1.106:8888"
    }
    
    public static func performValidate(_ command : ValidateCommand, completion: @escaping (_ response : ValidateResponse?, _ error: String?) -> Void){
        command.token = getToken()
        NetworkAdapter.performCommand("\(getHost())/restful/validate", command: command, completion: completion)
    }
    
    public static func performLogin(_ command : LoginCommand, completion: @escaping (_ response : LoginResponse?, _ error: String?) -> Void){
        NetworkAdapter.performCommand("\(getHost())/restful/login", command: command, completion: completion)
    }
    
    public static func performPostCommand(_ command : PostCommand, completion: @escaping (_ response : PostResponse?, _ error: String?) -> Void){
        command.token = getToken()
        NetworkAdapter.performCommand("\(getHost())/restful/latestposts-mini", command: command, completion: completion)
    }
    
    public static func performSearchCommand(_ command : SearchCommand, completion: @escaping (_ response : SearchResponse?, _ error: String?) -> Void){
//        NetworkAdapter.performCommand("https://ttdc.us/restful/latestConversations", command: command, completion: completion)
        command.token = getToken()
        NetworkAdapter.performCommand("\(getHost())/restful/search-mini", command: command, completion: completion)
    }
    
    public static func performPostCommand(_ command : TopicCommand, completion: @escaping (_ response : TopicResponse?, _ error: String?) -> Void){
        command.token = getToken()
        NetworkAdapter.performCommand("\(getHost())/restful/topic-mini", command: command, completion: completion)
    }
    
    public static func performAutocompleteCommand(_ command : AutoCompleteCommand, completion: @escaping (_ response : AutoCompleteResponse?, _ error: String?) -> Void){
        command.token = getToken()
        NetworkAdapter.performCommand("\(getHost())/restful/autocomplete", command: command, completion: completion)
    }
    
    public static func performPostCrudCommand(_ command: PostCrudCommand, completion: @escaping (_ response: PostCrudResponse?, _ error: String?)->Void){
        command.token = getToken()
        NetworkAdapter.performCommand("\(getHost())/restful/post", command: command, completion: completion)
    }
    
    public static func performRegisterForPushCommand(_ command: RegisterCommand, completion: @escaping (_ response: RegisterResponse?, _ error: String?)->Void){
        command.token = getToken()
        NetworkAdapter.performCommand("\(getHost())/restful/register", command: command, completion: completion)
    }
    
    public static func performForumCommand(_ command : ForumCommand, completion: @escaping (_ response : ForumResponse?, _ error: String?) -> Void){
        command.token = getToken()
        NetworkAdapter.performCommand("\(getHost())/restful/forum", command: command, completion: completion)
    }
    
    public static func performLikeCommand(_ command : LikeCommand, completion: @escaping (_ response : LikeResponse?, _ error: String?) -> Void){
        command.token = getToken()
        NetworkAdapter.performCommand("\(getHost())/restful/like", command: command, completion: completion)
    }
    
    public static func performConnectCommand(_ command : ConnectCommand, completion: @escaping (_ response : ConnectResponse?, _ error: String?) -> Void){
        command.token = getToken()
        NetworkAdapter.performCommand("\(getHost())/restful/connect", command: command, completion: completion)
    }
    
    public static func performServerEventListCommand(_ command : ServerEventListCommand, completion: @escaping (_ response : ServerEventListResponse?, _ error: String?) -> Void){
        command.token = getToken()
        NetworkAdapter.performCommand("\(getHost())/restful/serverEventList-mini", command: command, completion: completion)
    }
    
}
