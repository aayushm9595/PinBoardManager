//
//  Categories.swift
//  PinboardManager
//
//  Created by Aayush Maheshwari on 23/04/19.
//  Copyright © 2019 aayushm95. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CategoryKeys{
    let title = String("title")
    let photoCount = String("photo_count")
    let iD = String("id")
    let links = String("links")
}
open class Categories: NSCoding {
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: Header.title)
        aCoder.encode(photoCount, forKey: Header.photoCount)
        aCoder.encode(id, forKey: Header.iD)
        aCoder.encode(links, forKey: Header.links)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: Header.title) as? String
        self.photoCount  = aDecoder.decodeObject(forKey: Header.photoCount) as? Int
        self.id = aDecoder.decodeObject(forKey: Header.iD) as? Int
        self.links = aDecoder.decodeObject(forKey: Header.links) as? Links
    }
    
    
    // MARK: Properties
    public var title: String?
    public var photoCount: Int?
    public var id: Int?
    public var links: Links?
    private let Header = CategoryKeys()
    convenience public init(object: Any) {
        self.init(json:JSON(object))
    }
    
   public init(json : JSON)
    {
        title = json[Header.title].string
        photoCount = json[Header.photoCount].int
        id = json[Header.iD].int
        links = Links(json : json[Header.links])
    }
    
    func getDictionary() -> [String: Any] {
        var dict = [String:Any]()
        if title != nil {dict[Header.title] = title}
        if photoCount != nil {dict[Header.photoCount] = photoCount}
        if id != nil {dict[Header.iD] = id}
        if links != nil {dict[Header.links] = links?.getDictionary()}
        return dict
    }
}
