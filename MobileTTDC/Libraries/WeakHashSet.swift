//
//  WeakHashSet.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/21/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import Foundation

public class WeakObject<T: AnyObject> {
    weak var value : T?
    
    init (value: T) {
        self.value = value
    }
}




//class WeakObject<T: AnyObject>: Equatable, Hashable {
//    weak var object: T?
//    init(object: T) {
//        self.object = object
//    }
//    
//    var hashValue: Int {
//        if let object = self.object { return unsafeAddressOf(object).hashValue }
//        else { return 0 }
//    }
//}
//
//func == <T> (lhs: WeakObject<T>, rhs: WeakObject<T>) -> Bool {
//    return lhs.object === rhs.object
//}
//
//
//class WeakObjectSet<T: AnyObject> {
//    var objects: Set<WeakObject<T>>
//    
//    init() {
//        self.objects = Set<WeakObject<T>>([])
//    }
//    
//    init(objects: [T]) {
//        self.objects = Set<WeakObject<T>>(objects.map { WeakObject(object: $0) })
//    }
//    
//    var allObjects: [T] {
//        return objects.flatMap { $0.object }
//    }
//    
//    func contains(object: T) -> Bool {
//        return self.objects.contains(WeakObject(object: object))
//    }
//    
//    func addObject(object: T) {
//        self.objects.formUnion([WeakObject(object: object)])
//    }
//    
//    func addObjects(objects: [T]) {
//        self.objects.unionInPlace(objects.map { WeakObject(object: $0) })
//    }
//}
