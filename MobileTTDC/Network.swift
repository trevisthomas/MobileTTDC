//
//  Network.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 5/30/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public class Network {
    public static func performLogin(command : LoginCommand, completion: (response : LoginResponse?, error: String?) -> Void){
        NetworkAdapter.performCommand("http://ttdc.us/restful/login", command: command, completion: completion)
    }
}