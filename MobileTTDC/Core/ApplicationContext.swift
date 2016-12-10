

//
//  ApplicationContext.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/2/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation
import UIKit

open class ApplicationContext /*: AuthenticatedUserDataProvider*/  {
    open static let currentUserKey : String = "us.ttdc.CurrentUser"
    open static let styleChangedNotificationKey : String = "us.ttdc.StyleChanged"
    open static let styleDark : String = "darkStyle"
    open static let styleLight : String = "lightStyle"

    let broadcaster : Broadcaster
    let latestPostsModel : LatestPostsModel<LatestPostsViewController> //TODO: Remove this class generic. Use method generic
//    let latestPostsModel = LatestPostsModel(broadcaster: broadcaster)
    
    fileprivate static let defaultStyle : String = styleLight
    
    public enum Style {
        case dark
        case light
    }
    
    open var imageCache : [String: UIImage] = [:]
    
    
    init(){
        broadcaster = Broadcaster()
        latestPostsModel = LatestPostsModel(broadcaster: broadcaster)
    }
    
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

    fileprivate(set) var currentStyleName : String = ApplicationContext.defaultStyle {
        didSet{
            UIApplication.shared.statusBarStyle = getCurrentStyle().statusBarStyle()
//            UINavigationBar.appearance().isOpaque = false
            //setTranslucent(false)

            //Trevis, remember that you can set colors globally
//            UIView.appearance().backgroundColor = getCurrentStyle().navigationColor()
            
            UITextField.appearance().keyboardAppearance = getCurrentStyle().keyboardAppearance()
            
//            UITextView.appearance().keyboardAppearance = getCurrentStyle().keyboardAppearance()
            
//            UITextView.appear
            NotificationCenter.default.post(name: Notification.Name(rawValue: ApplicationContext.styleChangedNotificationKey), object: nil)
        }
    }

    
//    private(set) var currentStyle : AppStyle = AppStyleLight() {
//        didSet{
//            NSNotificationCenter.defaultCenter().postNotificationName(ApplicationContext.styleChangedNotificationKey, object: nil)
//        }
//    }
    
    fileprivate var previousUser: Person? = nil
    fileprivate var _currentUser : Person? = nil {
        willSet{
            previousUser = _currentUser
        }
        
        didSet{
//            NSNotificationCenter.defaultCenter().postNotificationName(ApplicationContext.currentUserKey, object: _currentUser?.login) //Sigh.  I hate struts.  Were they a bad idea?
            
            guard previousUser?.login != _currentUser?.login else {
                return
            }
            
            var objects = [Any?]()
            objects.append(_currentUser?.login)
            
            
            if let login = _currentUser?.login {
                NotificationCenter.default.post(name: Notification.Name(rawValue: ApplicationContext.currentUserKey), object: nil, userInfo: ["login" : login])
            } else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: ApplicationContext.currentUserKey), object: nil, userInfo: [:])
            }
            
        }
    }
    fileprivate(set) open var token: String? = nil //WTF both?
    
    //Trevis: Your thought for these stashes was just to have a temporary place to hang on to user entered text in dialogs so that if they accidentally leave and the VC closes, that coming back, the text would still be avail.
    open var commentStash : String? = nil
    open var topicStash: String? = nil
    
    open var deviceToken: String? = nil {
        didSet{
            registerForPush()
        }
    }
    
    
    
    fileprivate struct PersistantKeys {
        static let token = "token"
        static let style = "style"
    }
    
    open func saveState(){
        let defaults = UserDefaults.standard
        
        defaults.setValue(token, forKey: PersistantKeys.token)
        defaults.setValue(currentStyleName, forKeyPath: PersistantKeys.style)
        
        defaults.synchronize()
    }
    
    open func loadState(){
        let defaults = UserDefaults.standard
        
        if let t = defaults.string(forKey: PersistantKeys.token){
            
//            _currentUser = nil
            self.token = t
            
            let cmd = ValidateCommand()
            
            Network.performValidate(cmd){
                (response, message) -> Void in
                guard (response != nil) else {
                    self.logoff()
                    return;
                }
                
                DispatchQueue.main.async {
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
        
        
//        if let style = defaults.string(forKey: PersistantKeys.style) {
//            self.currentStyleName = style
//        } else {
//            self.currentStyleName = ApplicationContext.defaultStyle
//        }
        
        loadStyle()
    }
    
    public func loadStyle() {
        let defaults = UserDefaults.standard
        if let style = defaults.string(forKey: PersistantKeys.style) {
            self.currentStyleName = style
        } else {
            self.currentStyleName = ApplicationContext.defaultStyle
        }
    }
    
//    fileprivate var _latestPosts : [Post] = [] {
//        didSet{
//            latestPostsObserver?.latestPostsUpdated()
//        }
//    }
//    
//    /*private*/ var _latestConversations : [Post] = [] {
//        didSet{
//            latestConversationsObserver?.latestConversationsUpdated()
//        }
//    }
    
    open var displayMode : DisplayMode = DisplayMode.latestGrouped {
        didSet{
            
            //Trevis, do you need to change the displaymode external to the Latest posts?
//            reloadLatestPosts()
//            latestPostsObserver?.displayModeChanged()
            
        }
    }
//    open var latestPostsObserver : LatestPostsObserver? = nil
//    
//    open var latestConversationsObserver : LatestConversationsObserver? = nil
    
    open func reloadAllData(){
//        reloadLatestPosts()
//        reloadLatestConversations()
        
        commentStash = nil
        topicStash = nil

    }
    
    open func authenticate(_ login: String, password: String, completion: @escaping (_ success: Bool, _ details: String) -> ()) {
        let cmd = LoginCommand(login: login, password: password)
        
//        _currentUser = nil
//        token = nil
        
        Network.performLogin(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                self._currentUser = nil
                self.token = nil
                completion(false, "Invalid login or password")
                return;
            }
            
//            if let c = self._currentUser {
//                if let newPerson = response?.person {
//                    if (c.login == newPerson.login) {
//                        print("User didnt change")
//                        return; //Didnt change
//                    }
//                }
//            }
            
            
            self.token = response?.token
            self._currentUser = response?.person
            self.saveState()
            self.registerForPush()
            completion(true, "Welcome back, \((response?.person?.name)!)")
            self.reloadAllData()
        };
    }
    
    fileprivate func registerForPush(){
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
    
    public func currentUser() -> Person? {
        return _currentUser
    }
    
    public func logoff() {
        _currentUser = nil
        currentStyleName = ApplicationContext.defaultStyle
        token = nil
        self.saveState()
    }
    
}
/*
extension ApplicationContext : LatestPostsDataProvider {
//    public func latestPosts() -> [Post] {
//        return _latestPosts
//    }
    public func currentUser() -> Person? {
        return _currentUser
    }
    
    public func logoff() {
        _currentUser = nil
        currentStyleName = ApplicationContext.defaultStyle
        token = nil
        self.saveState()
    }

//    public func reloadLatestPosts() {
//        _latestPosts = []
//        switch displayMode{
//        case .latestGrouped:
//            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_GROUPED)
//        case .latestFlat:
//            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_FLAT)
//        }
//    }
//    
//    fileprivate func loadlatestPostDataFromWebservice(_ action: PostCommand.Action){
//        let cmd = PostCommand(action: action, pageNumber: 1)
//        
//        Network.performPostCommand(cmd){
//            (response, message) -> Void in
//            guard (response != nil) else {
//                self.latestPostsObserver?.networkError("Webservice request failed.")
//                return;
//            }
//            
//            self._latestPosts = (response?.list)!
//            
//            if self.displayMode == .latestGrouped {
//                self._latestPosts = self._latestPosts.flattenPosts()
//            }
//        };
//    }
    
    
}
 */

//extension ApplicationContext : LatestConversationsDataProvider {
//    public func latestConversations() -> [Post] {
//        return _latestConversations
//    }
//    
//    public func reloadLatestConversations() {
//        self._latestConversations = []
//        loadConversationsFromWebservice()
//    }
//    
//    fileprivate func loadConversationsFromWebservice(){
//        let cmd = SearchCommand(postSearchType: SearchCommand.PostSearchType.CONVERSATIONS)
//        
//        Network.performSearchCommand(cmd){
//            (response, message) -> Void in
//            guard (response != nil) else {
//                self.latestConversationsObserver?.networkError("Webservice request failed.")
//                return;
//            }
//            
//            self._latestConversations = (response?.list)!
//        };
//    }
//    
//}


extension UIViewController : CurrentUserProtocol {
    func registerForUserChangeUpdates() {
        NotificationCenter.default.addObserver(self, selector: #selector(catchUserChangedNotification), name: NSNotification.Name(rawValue: ApplicationContext.currentUserKey), object: nil)
    }
    
    func catchUserChangedNotification(_ notification: Notification) {
        onCurrentUserChanged()
    }
    
    func onCurrentUserChanged() {
        //Default does nothing
    }
}

extension ApplicationContext : ServerEventMonitorDelegate {
    func postUpdated(post : Post) {
        self.broadcaster.postUpdated(post: post)
    }
    func postAdded(post : Post) {
        self.broadcaster.postAdded(post: post)
    }
    
    func reloadPosts() {
        self.broadcaster.reloadPosts()
    }

}


