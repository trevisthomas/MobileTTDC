//
//  ApplicationContext.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/2/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation
import UIKit

public class ApplicationContext : AuthenticatedUserDataProvider {
    private var _currentUser : Person? = nil
    private(set) public var token: String? = nil //WTF both?
    private var _latestPosts : [Post] = [] {
        didSet{
            latestPostsObserver?.latestPostsUpdated()
        }
    }
    
    private var _latestConversations : [Post] = [] {
        didSet{
            latestConversationsObserver?.latestConversationsUpdated()
        }
    }
    
    public var displayMode : DisplayMode = DisplayMode.LatestGrouped {
        didSet{
            reloadLatestPosts()
            latestPostsObserver?.displayModeChanged()
            
        }
    }
    public var latestPostsObserver : LatestPostsObserver? = nil
    
    public var latestConversationsObserver : LatestConversationsObserver? = nil
    
    public func reloadAllData(){
        reloadLatestPosts()
        reloadLatestConversations()
    }
    
    public func authenticate(login: String, password: String, completion: (success: Bool, details: String) -> ()) {
        let cmd = LoginCommand(login: login, password: password)
        
        _currentUser = nil
        token = nil
        Network.performLogin(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                self._currentUser = nil
                self.token = nil
                completion(success: false, details: "Invalid login or password")
                return;
            }
            self.token = response?.token
            self._currentUser = response?.person
            completion(success: true, details: "Welcome back, \((response?.person?.name)!)")
            self.reloadAllData()
        };
    }
}

extension ApplicationContext : LatestPostsDataProvider {
    public func latestPosts() -> [Post] {
        return _latestPosts
    }
    public func currentUser() -> Person? {
        return _currentUser
    }

    public func reloadLatestPosts() {
        _latestPosts = []
        switch displayMode{
        case .LatestGrouped:
            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_GROUPED)
        case .LatestFlat:
            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_FLAT)
        }
    }
    
    private func loadlatestPostDataFromWebservice(action: PostCommand.Action){
        let cmd = PostCommand(action: action, pageNumber: 1)
        
        Network.performPostCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                self.latestPostsObserver?.networkError("Webservice request failed.")
                return;
            }
            
            self._latestPosts = (response?.list)!
        };
    }
}

extension ApplicationContext : LatestConversationsDataProvider {
    public func latestConversations() -> [Post] {
        return _latestConversations
    }
    
    public func reloadLatestConversations() {
        self._latestConversations = []
        loadConversationsFromWebservice()
    }
    
    private func loadConversationsFromWebservice(){
        let cmd = SearchCommand(postSearchType: SearchCommand.PostSearchType.CONVERSATIONS)
        
        Network.performSearchCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                self.latestConversationsObserver?.networkError("Webservice request failed.")
                return;
            }
            
            self._latestConversations = (response?.list)!
        };
    }
    
}