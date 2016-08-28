//
//  SearchCommand.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/11/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

/*
 
 {
 "postSearchType": "CONVERSATIONS",
 "pageNumber": 1,
 "sortOrder": "BY_DATE",
 "sortDirection": "DESC"
 }
 
 */
public class SearchCommand : Command {
    public enum PostSearchType : String{
        case CONVERSATIONS = "CONVERSATIONS"
        case ALL = "ALL"
        //TODO: Add the rest
    }
    
    public enum SortOrder : String{
        case BY_DATE = "BY_DATE"
        //TODO: Add the rest
    }
    
    public enum SortDirection : String{
        case DESC = "DESC"
        case ASC = "ASC"
    }
    
    let postSearchType: PostSearchType
    let pageNumber: Int
    let sortOrder: SortOrder?
    let sortDirection: SortDirection?
    let phrase: String?
    
    public var token: String?
    
    public func toJSON() -> JSON? {
        return jsonify([
            "postSearchType" ~~> self.postSearchType,
            "pageNumber" ~~> self.pageNumber,
            "sortOrder" ~~> self.sortOrder ?? nil,
            "sortDirection" ~~> self.sortDirection ?? nil,
            "token" ~~> self.token ?? nil,
            "phrase" ~~> self.phrase ?? nil
            ])
    }
    
    public init( postSearchType: PostSearchType, pageNumber: Int = 1, sortOrder: SortOrder = SortOrder.BY_DATE,
                 sortDirection: SortDirection = SortDirection.DESC){
        self.postSearchType = postSearchType
        self.pageNumber = pageNumber
        self.sortOrder = sortOrder
        self.sortDirection = sortDirection
        self.phrase = nil
    }
    
    public init( phrase: String, postSearchType: PostSearchType, pageNumber: Int = 1, sortOrder: SortOrder = SortOrder.BY_DATE,
                 sortDirection: SortDirection = SortDirection.DESC){
        self.postSearchType = postSearchType
        self.pageNumber = pageNumber
        self.sortOrder = sortOrder
        self.sortDirection = sortDirection
        self.phrase = phrase
    }
    
    //TODO: Add more constructors for more search types
}