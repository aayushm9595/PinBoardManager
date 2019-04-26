//
//  Links.swift
//  PinboardManager
//
//  Created by Aayush Maheshwari on 23/04/19.
//  Copyright © 2019 aayushm95. All rights reserved.
//

import Foundation
import SwiftyJSON


struct LinksKeys{
    let selfLink = String("self")
    let html = String("html")
    let photos = String("photos")
    let download = String("download")
    let likes = String("likes")
}

open class Links: NSCoding {
    public var selfLink: String?
    public var html: String?
    public var photos: String?
    public var download: String?
    public var likes: String?
    private let Header = LinksKeys()
    convenience public init(object: Any) {
        self.init(json: JSON(object))
    }
    
   public init(json : JSON) {
        selfLink = json[Header.selfLink].string
        html = json[Header.html].string
        photos = json[Header.photos].string
        download = json[Header.download].string
        likes = json[Header.likes].string
    }
    
    func getDictionary() -> [String: Any] {
        var dict = [String:Any]()
        if selfLink != nil {dict[Header.selfLink] = selfLink}
        if html != nil {dict[Header.html] = html}
        if photos != nil {dict[Header.photos] = photos}
        if download != nil {dict[Header.download] = download}
        if likes != nil {dict[Header.likes] = likes}
        return dict
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(selfLink, forKey: Header.selfLink)
        aCoder.encode(html, forKey: Header.html)
        aCoder.encode(photos, forKey: Header.photos)
        aCoder.encode(download, forKey: Header.download)
        aCoder.encode(likes, forKey: Header.likes)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.selfLink = aDecoder.decodeObject(forKey: Header.selfLink) as? String
        self.html = aDecoder.decodeObject(forKey: Header.html) as? String
        self.photos = aDecoder.decodeObject(forKey: Header.photos) as? String
        self.download = aDecoder.decodeObject(forKey: Header.download) as? String
        self.likes = aDecoder.decodeObject(forKey: Header.likes) as? String
    }
    
}
