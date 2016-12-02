//
//  ServerEventMonitor.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 12/1/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

protocol ServerEventMonitorDelegate {
    func postUpdated(post : Post)
    func postAdded(post : Post)
    func reloadPosts()
}

class ServerEventMonitor : NSObject {
    private var updateFrequency = 10.0
    private var connectionId : String?
    private var timer : Timer?
    private let delegate : ServerEventMonitorDelegate
    
    init(delegate : ServerEventMonitorDelegate){
        self.delegate = delegate
    }
    
    func connect(){
        stop()
        connectionId = nil
        let cmd = ConnectCommand()
        Network.performConnectCommand(cmd) {
            (result, messge) in
            self.connectionId = result?.connectionId
            print("Connected to server with id: \(self.connectionId)")
        }
    }
    
    func start(){
        stop()
        timer = Timer.scheduledTimer(timeInterval: updateFrequency, target: self, selector: #selector(timerDidFire), userInfo: nil, repeats: true)
    }
    
    func stop(){
        timer?.invalidate()
    }
    
    func timerDidFire(){
        print("Server event monitor debug.")
        guard let id = connectionId else {
            connect()
            return
        }
        let cmd = ServerEventListCommand(connectionId: id)
        Network.performServerEventListCommand(cmd) {
            (result, messge) in
            
            guard let events = result?.events else {
                return
            }
            for event in events {
                self.processEvent(event: event)
            }
        }
    }
    
    private func processEvent(event: ServerEvent){
        switch(event.type){
        case "TRAFFIC":
            print(event.sourcePerson!.login)
        case "EDIT", "DELETE":
            print(event.sourcePost!.postId)
            delegate.postUpdated(post: event.sourcePost!)
        case "NEW":
            print("New post \(event.sourcePost!.postId)")
            delegate.postAdded(post: event.sourcePost!)
        case "NEW_TAG", "REMOVED_TAG":
            print(event.sourceTagAss!.tag.type)
            let cmd = PostCrudCommand(postId: event.sourceTagAss!.post!.postId)
            
            Network.performPostCrudCommand(cmd){
                (response, message) in
                guard let post = response?.post else {
                    return
                }
                self.delegate.postUpdated(post: post)
            }
            
            
        case "RESET_SERVER_BROADCAST":
            connectionId = nil
            print("Expired id.")
            delegate.reloadPosts()
        default:
            break
        }
    }
    
}
