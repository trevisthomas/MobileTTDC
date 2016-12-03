//
//  ServerEvent.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 12/1/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation


// This was one of the worst things i've encounteded with dealing with ttdc.  It uses these generic events that it treats like Event<?,?> so what happens in reality is that those types change but i have no idea how to handle the types refering to different classes of source.  
// Ok, i made changes on the server to hide the Event<?,?> abonination.

public struct ServerEvent : Decodable{
    let sourcePost : Post?
    let sourcePerson : Person?
    let sourceTagAss : TagAssociation?
    let type : String
    
    public init?(json: JSON) {
        type = ("type" <~~ json)!
        sourcePerson = ("sourcePerson" <~~ json)
        sourcePost = ("sourcePost" <~~ json)
        sourceTagAss = ("sourceTagAssociation" <~~ json)
    }
}
