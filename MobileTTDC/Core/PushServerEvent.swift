//
//  PushServerEvent.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 12/23/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation


class PushServerEvent {
    let delegate : ServerEventMonitorDelegate!
    init (delegate : ServerEventMonitorDelegate) {
        self.delegate = delegate
    }
    
    func pushEvent(event : [String: AnyObject]) {
        guard let type = event["type"] as? String else { fatalError() }
        guard let guid = event["guid"] as? String else { fatalError() }
        
        switch(type){
        case "TRAFFIC":
            fetchPersonAndFire(personId : guid){
                (person) in
                self.delegate.traffic(person: person)
            }

        case "EDIT", "DELETE":
            fetchPostAndFire(postId : guid) {
                (post) in
                self.delegate.postUpdated(post: post)
            }
//            delegate.postUpdated(post: event.sourcePost!)
        case "NEW":
            fetchPostAndFire(postId : guid){
                (post) in
                self.delegate.postAdded(post: post)
            }
//            delegate.postAdded(post: event.sourcePost!)
//        case "NEW_TAG", "REMOVED_TAG":
//            print(event.sourceTagAss!.tag.type)
            //Trevis, you're ignoreing these because tag add/remove also send post edit events which is what you use to update the ui.
            
        default:
            break
        }
    }
    
    private func fetchPostAndFire(postId : String, callback: @escaping (Post)->Void) {
        let cmd = PostCrudCommand(postId: postId)
        
        Network.performPostCrudCommand(cmd){
            (response, message) -> Void in
            
            guard let post = response?.post else { return }
            
            invokeLater {
                callback(post)
            }
        }
    }
    
    private func fetchPersonAndFire(personId : String, callback: @escaping (Person)->Void) {
        let cmd = PersonCommand(personId: personId)
        
        Network.performPerson(cmd){
            (response, message) -> Void in
            
            guard let person = response?.person else { return }
            
            invokeLater {
                callback(person)
            }
        }
    }
}
