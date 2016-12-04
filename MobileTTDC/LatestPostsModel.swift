//
//  LatestPostModel.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 12/3/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

protocol LatestPostDelegate {
    func dataLoadError(message : String)
    func dataUpdated(displayMode : DisplayMode)
}

class LatestPostsModel {
    private let flatPageSize = 20;
    private let groupedPageSize = 5;
    
    var delegate : LatestPostDelegate?
    
    init(broadcaster : Broadcaster) {
//        broadcaster.subscribe(consumer: self)
        
        broadcaster.subscribeForPostAdd(consumer: self)
        broadcaster.subscribe(consumer: self)
    }
    
    private var postDictionary : [DisplayMode : (list : [Post], page: Int)] = [:]
    
    func getPosts(forMode: DisplayMode) -> [Post]? {
        return postDictionary[forMode]?.list
    }
    
    func reloadData(displayMode : DisplayMode, completion: @escaping ([Post]?) -> Void){
        
        let localCompletion = {(posts : [Post], totalPosts : Int) -> Void in
            self.postDictionary[displayMode] = (list: posts, page: 1)
//            self.delegate?.dataUpdated(displayMode: displayMode)
            
            completion(posts)
        }
        
        switch displayMode {
        case .latestGrouped:
            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_GROUPED, flatten: true, pageNumber: 1, pageSize:groupedPageSize, completion: localCompletion)
        case .latestFlat:
            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_FLAT, pageNumber: 1, pageSize:flatPageSize, completion: localCompletion)
        case .latestConversations:
            loadlatestConversationsFromWebservice(pageNumber: 1, pageSize: flatPageSize, completion: localCompletion)
        case .latestThreads:
            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_THREADS, pageNumber: 1, pageSize:flatPageSize, completion: localCompletion)
        }
    }
    
    func loadNextPage(displayMode : DisplayMode, completion: @escaping ([Post]?) -> Void){
        guard let tuple = postDictionary[displayMode] else {
            print("Error: Post dictionary is trying to load a new page when the first page was never loaded.")
            return
        }
        
        let pageNumber = tuple.page + 1
        
        let localCompletion = {(posts : [Post]?, totalPosts : Int?) -> Void in
            self.postDictionary[displayMode]?.list.append(contentsOf: posts!)
            self.postDictionary[displayMode]?.page = pageNumber
//            self.delegate?.dataUpdated(displayMode: displayMode)
            
            completion(posts)
        }
        
        switch displayMode {
        case .latestGrouped:
            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_GROUPED, pageNumber: pageNumber, pageSize:groupedPageSize, completion: localCompletion)
        case .latestFlat:
            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_FLAT, pageNumber: pageNumber, pageSize:flatPageSize, completion: localCompletion)
        case .latestConversations:
            loadlatestConversationsFromWebservice(pageNumber: pageNumber, pageSize: flatPageSize, completion: localCompletion)
        case .latestThreads:
            loadlatestPostDataFromWebservice(PostCommand.Action.LATEST_THREADS, pageNumber: pageNumber, pageSize:flatPageSize, completion: localCompletion)
        }
        
    }
    
    fileprivate func loadlatestPostDataFromWebservice(_ action: PostCommand.Action, flatten : Bool = false , pageNumber: Int = 1, pageSize: Int, completion: @escaping ([Post], Int) -> Void){
        let cmd = PostCommand(action: action, pageNumber: pageNumber, pageSize: pageSize)
        
        Network.performPostCommand(cmd){
            (response, message) -> Void in
//            guard (response != nil) else {
//                self.delegate?.dataLoadError(message: message!)
//                return;
//            }
            
            guard let r = response else {
                self.delegate?.dataLoadError(message: message!)
//                completion(nil, nil)
                return;
            }
            
//            if self.getApplicationContext().displayMode == .latestGrouped {
            if flatten {
                completion(r.list.flattenPosts(), r.totalResults)
            } else {
                completion(r.list, r.totalResults)
            }
        };
    }
    
    fileprivate func loadlatestConversationsFromWebservice(pageNumber: Int, pageSize: Int, completion: @escaping ([Post], Int) -> Void) {
        let cmd = SearchCommand(postSearchType: SearchCommand.PostSearchType.CONVERSATIONS, pageSize: pageSize, pageNumber: pageNumber)
        
        Network.performSearchCommand(cmd){
            (response, message) -> Void in
            
            guard let r = response else {
                self.delegate?.dataLoadError(message: message!)
//                completion(nil, nil)
                return;
            }
            
            completion(r.list, r.totalResults)
        };
    }
    
}

extension LatestPostsModel : BroadcastPostAddConsumer {
    func onPostAdded(post : Post) {
        print("LatestPostModel: Post Added")
    }
    func reloadPosts() {
        print("LatestPostModel: reload all")
    }
}
extension LatestPostsModel : BroadcastEventConsumer {
    func observingPostId(postId: String) -> Bool {
        return true;
    }
    func onPostUpdated(post : Post) {
        print("LatestPostModel: Post updated")
        
    }
}
