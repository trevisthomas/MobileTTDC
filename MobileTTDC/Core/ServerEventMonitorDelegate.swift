//
//  ServerEventMonitorDelegate.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 12/24/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

protocol ServerEventMonitorDelegate {
    func postUpdated(post : Post)
    func postAdded(post : Post)
    func traffic(person: Person)
    func reloadPosts()
}
