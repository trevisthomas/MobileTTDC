//
//  LatestPostsViewControllerDelegate.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/2/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public protocol AuthenticatedUserObserver {
    func authenticatedUserChanged()
}

public protocol AuthenticatedUserDataProvider {
    var token : String? {get}
    func currentUser() -> Person?
    func authenticate(login : String, password: String, completion: (success : Bool, details : String)->())
}

public protocol LatestPostsObserver: AuthenticatedUserObserver {
    func latestPostsUpdated()
    func displayModeChanged()
    func networkError(error: String)
}

public protocol LatestPostsDataProvider: AuthenticatedUserDataProvider{
    func latestPosts() -> [Post]
    var displayMode : DisplayMode {get set}
    var latestPostsObserver : LatestPostsObserver?  {get set}
    func reloadLatestPosts()
}

public protocol LatestConversationsObserver: AuthenticatedUserObserver  {
    func latestConversationsUpdated()
    func networkError(error: String)
}

public protocol LatestConversationsDataProvider: AuthenticatedUserDataProvider {
    func latestConversations() -> [Post]
    var latestConversationsObserver : LatestConversationsObserver?  {get set}
    func reloadLatestConversations()
}