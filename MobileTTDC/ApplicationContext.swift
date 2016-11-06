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
    public static let currentUserKey : String = "us.ttdc.CurrentUser"
    public static let styleChangedNotificationKey : String = "us.ttdc.StyleChanged"
    public static let styleDark : String = "darkStyle"
    public static let styleLight : String = "lightStyle"

    private static let defaultStyle : String = styleLight
    
    public enum Style {
        case Dark
        case Light
    }
    
    public var imageCache : [String: UIImage] = [:]
    
//    public var currentStyleName : Style = .Light{
//        didSet{
//            switch currentStyleName {
//            case .Light:
//                currentStyle = AppStyleLight()
//                
//            case .Dark:
//                currentStyle = AppStyleDark()
//                
//            }
//        }
//    }
    
    
    func setStyleDark(){
        currentStyleName = ApplicationContext.styleDark
        saveState()
    }
    
    func setStyleLight(){
        currentStyleName = ApplicationContext.styleLight
        saveState()
    }
    
    func isStyleLight() -> Bool{
        return currentStyleName == ApplicationContext.styleLight
    }
    
    func isStyleDark() -> Bool{
        return currentStyleName == ApplicationContext.styleDark
    }
    
    func getCurrentStyle() -> AppStyle {
        if currentStyleName == ApplicationContext.styleDark {
            return AppStyleDark()
        } else {
            return AppStyleLight()
        }
        
    }

    private(set) var currentStyleName : String = ApplicationContext.defaultStyle {
        didSet{
            UIApplication.sharedApplication().statusBarStyle = getCurrentStyle().statusBarStyle()
            
            
//            UITextField.appearance().keyboardAppearance = .Dark
            NSNotificationCenter.defaultCenter().postNotificationName(ApplicationContext.styleChangedNotificationKey, object: nil)
        }
    }

    
//    private(set) var currentStyle : AppStyle = AppStyleLight() {
//        didSet{
//            NSNotificationCenter.defaultCenter().postNotificationName(ApplicationContext.styleChangedNotificationKey, object: nil)
//        }
//    }
    
    private var _currentUser : Person? = nil {
        didSet{
//            NSNotificationCenter.defaultCenter().postNotificationName(ApplicationContext.currentUserKey, object: _currentUser?.login) //Sigh.  I hate struts.  Were they a bad idea?
            
            var objects = [Any?]()
            objects.append(_currentUser?.login)
            
            if let login = _currentUser?.login {
                NSNotificationCenter.defaultCenter().postNotificationName(ApplicationContext.currentUserKey, object: nil, userInfo: ["login" : login])
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName(ApplicationContext.currentUserKey, object: nil, userInfo: [:])
            }
            
        }
    }
    private(set) public var token: String? = nil //WTF both?
    
    //Trevis: Your thought for these stashes was just to have a temporary place to hang on to user entered text in dialogs so that if they accidentally leave and the VC closes, that coming back, the text would still be avail.
    public var commentStash : NSAttributedString? = nil
    public var topicStash: NSAttributedString? = nil
    
    public var deviceToken: String? = nil {
        didSet{
            registerForPush()
        }
    }
    
    init(){
        
    }
    
    private struct PersistantKeys {
        static let token = "token"
        static let style = "style"
    }
    
    public func saveState(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setValue(token, forKey: PersistantKeys.token)
        defaults.setValue(currentStyleName, forKeyPath: PersistantKeys.style)
        
        defaults.synchronize()
    }
    
    public func loadState(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let t = defaults.stringForKey(PersistantKeys.token){
            
//            _currentUser = nil
            self.token = t
            
            let cmd = ValidateCommand()
            
            Network.performValidate(cmd){
                (response, message) -> Void in
                guard (response != nil) else {
                    self.logoff()
                    return;
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.token = response?.token
                    self._currentUser = response?.person
                    self.registerForPush()
                    self.reloadAllData()
                }
                
            };
        } else {
            self.logoff()
            self.reloadAllData()
        }
        
        
        if let style = defaults.stringForKey(PersistantKeys.style) {
            self.currentStyleName = style
        } else {
            self.currentStyleName = ApplicationContext.defaultStyle
        }
    }
    
    private var _latestPosts : [Post] = [] {
        didSet{
            latestPostsObserver?.latestPostsUpdated()
        }
    }
    
    /*private*/ var _latestConversations : [Post] = [] {
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
        
        commentStash = nil
        topicStash = nil

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
            self.saveState()
            self.registerForPush()
            completion(success: true, details: "Welcome back, \((response?.person?.name)!)")
            self.reloadAllData()
        };
    }
    
    private func registerForPush(){
        guard let _ = token, let deviceToken = deviceToken else {
            print("Conditions not ready to register for push.  Missing either token or device token.")
            return
        }
        
        let cmd = RegisterCommand(deviceToken: deviceToken)
        
        Network.performRegisterForPushCommand(cmd){
            (response, message) -> Void in
            if message != nil {
                print("Push notification registration failed: \(message)")
                return;
            } else {
                print("Registered for push notifications.")
            }
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
    
    public func logoff() {
        _currentUser = nil
        currentStyleName = ApplicationContext.defaultStyle
        token = nil
        self.saveState()
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
            
            if self.displayMode == .LatestGrouped {
                self._latestPosts = self._latestPosts.flattenPosts()
            }
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
