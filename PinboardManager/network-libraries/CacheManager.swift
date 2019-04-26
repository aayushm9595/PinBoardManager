//
//  CacheManager.swift
//  PinboardManager
//
//  Created by Aayush Maheshwari on 25/04/19.
//  Copyright © 2019 aayushm95. All rights reserved.
//

import Foundation

open class CacheConfiguration{
    public var maxItems: Int = 50
    public var duration: TimeInterval = 2 * 60
    
    class func `default`() -> CacheConfiguration {
        return CacheConfiguration()
    }
}

open class CacheManager {
    
    public var configuration : CacheConfiguration
    private var cached = [String: CachedItem]()
    public var cacheSize : Int
    
   public init(config : CacheConfiguration)
    {
        self.configuration = config
        self.cacheSize = config.maxItems
        
        if(config.duration != 0)
        {
            Timer.scheduledTimer(withTimeInterval: config.duration, repeats: true) { (timer) in
                self.releaseResources()
            }
        }
    }
    
    func set(url: String, item: Data) {
        var cachedItem = cached[url]
        if cachedItem == nil {
            cachedItem = CachedItem(url: url, item: item)
            cached[url] = cachedItem
        }
    }
    
    func getItem(url: String) -> Data? {
        return cached[url]?.getItem()
    }
    
    func releaseResources() {
        if cached.count == configuration.maxItems {
            
             var leastRequestedKey: String?
             var leastRequestedTimes: Int = Int.max
             var time = Date()
             for key in cached.keys {
                if let cacheditem = cached[key] {
                    if cacheditem.requestedTimes < leastRequestedTimes {
                        leastRequestedKey = key
                        leastRequestedTimes = cacheditem.requestedTimes
                        time = cacheditem.intialTime
                    }
                    else if cacheditem.requestedTimes == leastRequestedTimes && cacheditem.intialTime < time {
                        time = cacheditem.intialTime
                        leastRequestedKey = key
                    }
                }
            }
        
            if leastRequestedKey != nil {
                cached.removeValue(forKey: leastRequestedKey!)
            }
        }
    }
}

open class CachedItem {
    private let url: String
    private let item: Data
    private(set) var intialTime = Date()
    private(set) var requestedTimes : Int = 0
    
   public init(url: String, item: Data) {
        self.url = url
        self.item = item
        self.intialTime = Date()
    }
    
    func getItem() -> Data {
        requestedTimes += 1
        return item
    }
}
