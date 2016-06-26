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
    
    public static func performLogin(command : LoginCommand, completion: (response : LoginResponse?, error: String?) -> Void){
        NetworkAdapter.performCommand("http://ttdc.us/restful/login", command: command, completion: completion)
    }
    
    public static func performPostCommand(command : PostCommand, completion: (response : PostResponse?, error: String?) -> Void){
        command.token = getToken()
        NetworkAdapter.performCommand("http://ttdc.us/restful/latestposts", command: command, completion: completion)
    }
    
    public static func performSearchCommand(command : SearchCommand, completion: (response : SearchResponse?, error: String?) -> Void){
//        NetworkAdapter.performCommand("https://ttdc.us/restful/latestConversations", command: command, completion: completion)
        command.token = getToken()
        NetworkAdapter.performCommand("http://ttdc.us/restful/latestConversations", command: command, completion: completion)
    }
    
    public static func performPostCommand(command : TopicCommand, completion: (response : TopicResponse?, error: String?) -> Void){
        command.token = getToken()
        NetworkAdapter.performCommand("http://ttdc.us/restful/topic", command: command, completion: completion)
    }
    
    private static func getToken() -> String? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.currentToken
    }
}