//
//  PostCrudResponse.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/10/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public struct PostCrudResponse : Response {
    public let post: Post
    public init?(json: JSON) {
        post = ("post" <~~ json)!
    }

}