

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
    
    private static let anonymous = Person()

    private(set) var broadcaster : Broadcaster!
    private(set) var latestPostsModel : LatestPostsModel<LatestPostsViewController>! //TODO: Remove this class generic. Use method generic
//    let latestPostsModel = LatestPostsModel(broadcaster: broadcaster)
    private var serverEventMonitor : ServerEventMonitor!
    
    private static let defaultStyle : String = styleDark
    private static let defaultDisplayMode : DisplayMode = .latestFlat
    
    public var connectionId : String? {
//        guard let id = serverEventMonitor.connectionId else {
//            return nil
//        }
//        return id
        return serverEventMonitor.connectionId
    }
    
    public enum Style {
        case dark
        case light
    }
    
    enum UserDefaultsKeys : String{
        case token = "token"
        case style = "style"
        case displayMode = "displayMode"
    }
    
    
    open var imageCache : [String: UIImage] = [:]
    
    
    init(){
//        broadcaster = Broadcaster()
//        latestPostsModel = LatestPostsModel(broadcaster: broadcaster)
    }
    
    func initialize(callback : @escaping (Person) -> Void) {
        broadcaster = Broadcaster()
        latestPostsModel = LatestPostsModel(broadcaster: broadcaster)
        
        serverEventMonitor = ServerEventMonitor(delegate: self)
        serverEventMonitor.connect()
        
        becomeActive(callback: callback)
        
        
    }
    
    func resignActive(){
        serverEventMonitor.stop()
    }
    
    func becomeActive(callback : @escaping (Person) -> Void = {_ in }){
        guard let _ = broadcaster else {
            //If the broadcaster isnt initialized i'm assuming that becomeActive is being called before init.
            return
        }
        loadState() {
            (person) in
//            if self._currentUser?.personId != person.personId {
                self._currentUser = person
//            }
            self.registerForPush()
            self.reloadAllData()
            self.serverEventMonitor.start()
            callback(person)
        }
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
    
//    fileprivate var previousUser: Person? = nil
    fileprivate var _currentUser : Person? = nil {
//        willSet{
//            previousUser = _currentUser
//        }
        
        didSet{
            
            guard oldValue?.login != _currentUser?.login else {
                return
            }
//
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
    
    
    open var displayMode : DisplayMode = ApplicationContext.defaultDisplayMode 
    
    //    open var displayMode : DisplayMode = DisplayMode.latestGrouped {
    //        didSet{
    //
    //            //Trevis, do you need to change the displaymode external to the Latest posts?
    ////            reloadLatestPosts()
    ////            latestPostsObserver?.displayModeChanged()
    //
    //        }
    //    }
    //    open var latestPostsObserver : LatestPostsObserver? = nil
    //
    //    open var latestConversationsObserver : LatestConversationsObserver? = nil

    
    open var deviceToken: String? = nil {
        didSet{
            registerForPush()
        }
    }
    
    
    
    
    open func saveState(){
        let defaults = UserDefaults.standard
        
        defaults.setValue(token, forKey: UserDefaultsKeys.token.rawValue)
        defaults.setValue(currentStyleName, forKeyPath: UserDefaultsKeys.style.rawValue)
        defaults.setValue(displayMode.rawValue, forKeyPath: UserDefaultsKeys.displayMode.rawValue)
        
        defaults.synchronize()
    }
    
    private func loadState(callback : @escaping (Person) -> Void){
        let defaults = UserDefaults.standard
        
        if let t = defaults.string(forKey: UserDefaultsKeys.token.rawValue){
            
//            _currentUser = nil
            self.token = t
            
            let cmd = ValidateCommand()
            
            Network.performValidate(cmd){
                (response, message) -> Void in
                guard let r = response else {
                    self.logoff()
                    callback(ApplicationContext.anonymous)
                    return;
                }
                
                DispatchQueue.main.async {
                    self.token = response?.token
//                    self._currentUser = response?.person
//                    self.registerForPush()
//                    self.reloadAllData()
                    callback(r.person!)
                }
                
            };
        } else {
//            self.logoff()
            self.reloadAllData()
            callback(ApplicationContext.anonymous)
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
        if let style = defaults.string(forKey: UserDefaultsKeys.style.rawValue) {
            self.currentStyleName = style
        } else {
            self.currentStyleName = ApplicationContext.defaultStyle
        }
        
        if let mode = defaults.string(forKey: UserDefaultsKeys.displayMode.rawValue) {
            self.displayMode = DisplayMode(rawValue: mode)!
        } else {
            self.displayMode = ApplicationContext.defaultDisplayMode
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
                self._currentUser = ApplicationContext.anonymous
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
    
    public func isAuthenticated() -> Bool {
        if _currentUser == nil || _currentUser?.personId == ApplicationContext.anonymous.personId{
            return false
        } else {
            return true
        }
    }
    
    public func logoff() {
        let cmd = RegisterCommand(deviceToken: "")
        
        Network.performRegisterForPushCommand(cmd){
            (response, message) -> Void in
            self.token = nil //Wow.
            self._currentUser = ApplicationContext.anonymous
            self.currentStyleName = ApplicationContext.defaultStyle
            self.displayMode = ApplicationContext.defaultDisplayMode
            self.saveState()

        };
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


