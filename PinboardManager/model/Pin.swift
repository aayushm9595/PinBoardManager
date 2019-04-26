//
//  Pin.swift
//  PinboardManager
//
//  Created by Aayush Maheshwari on 23/04/19.
//  Copyright © 2019 aayushm95. All rights reserved.
//

import Foundation
import SwiftyJSON


struct PinKeys {
    let height = String("height")
    let user = String("user")
    let id = String("id")
    let likes = String("likes")
    let width = String("width")
    let created_at = String("created_at")
    let urls = String("urls")
    let currentUserCollection = String("current_user_collection")
    let links = String("links")
    let likedByUser = String("liked_by_user")
    let categories = String("categories")
    let color = String("color")
}
open class Pin: NSCoding {
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(height, forKey: Header.height)
        aCoder.encode(user, forKey: Header.user)
        aCoder.encode(id, forKey: Header.id)
        aCoder.encode(likes, forKey: Header.likes)
        aCoder.encode(width, forKey: Header.width)
        aCoder.encode(createdAt, forKey: Header.created_at)
        aCoder.encode(urls, forKey: Header.urls)
        aCoder.encode(currentUserCollections, forKey: Header.currentUserCollection)
        aCoder.encode(links, forKey: Header.links)
        aCoder.encode(likedByUser, forKey: Header.likedByUser)
        aCoder.encode(categories, forKey: Header.categories)
        aCoder.encode(color, forKey: Header.color)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.height = aDecoder.decodeObject(forKey: Header.height) as? Int
        self.user = aDecoder.decodeObject(forKey: Header.user) as? User
        self.id = aDecoder.decodeObject(forKey: Header.id) as? String
        self.likes = aDecoder.decodeObject(forKey: Header.likes) as? Int
        self.width = aDecoder.decodeObject(forKey: Header.width) as? Int
        self.createdAt = aDecoder.decodeObject(forKey: Header.created_at) as? String
        self.urls = aDecoder.decodeObject(forKey: Header.urls) as? Urls
        self.currentUserCollections = aDecoder.decodeObject(forKey: Header.currentUserCollection) as? [Any]
        self.links = aDecoder.decodeObject(forKey: Header.links) as? Links
        self.likedByUser = aDecoder.decodeBool(forKey: Header.likedByUser)
        self.categories = aDecoder.decodeObject(forKey: Header.categories) as? [Categories]
        self.color = aDecoder.decodeObject(forKey: Header.color) as? String
    }
    
    // To Do  ----- GET Specific year, date and time of creation
    // MARK: Properties
    public var height: Int?
    public var user: User?
    public var id: String?
    public var likes: Int?
    public var width: Int?
    public var createdAt: String?
    public var urls: Urls?
    public var currentUserCollections: [Any]?
    public var links: Links?
    public var likedByUser: Bool = false
    public var categories: [Categories]?
    public var color: String?
    public var date: Date?
    private let Header = PinKeys()
    convenience public init(object: Any) {
        self.init(json: JSON(object))
    }
    
    public init(json: JSON) {
        height = json[Header.height].int
        user = User(json: json[Header.user])
        id = json[Header.id].string
        likes = json[Header.links].int
        width = json[Header.width].int
        createdAt = json[Header.created_at].string
        urls = Urls(json: json[Header.urls])
        if let items = json[Header.currentUserCollection].array { currentUserCollections = items.map { $0.object} }
        links = Links(json: json[Header.links])
        likedByUser = json[Header.likedByUser].boolValue
        if let items = json[Header.categories].array { categories = items.map { Categories(json: $0) } }
        color = json[Header.color].string
        guard let createdAt = createdAt else {return}
        var creationdate = String(createdAt.prefix(19))
        let dateformat = "yyyy-MM-dd HH:mm:ss"
        creationdate = creationdate.replacingOccurrences(of: "T", with: " ")
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateformat
        date = dateformatter.date(from: creationdate)
    }
    
    func getDictonary() -> [String : Any]{
        var dictionary: [String: Any] = [:]
        if height != nil{ dictionary[Header.height] = height }
        if user != nil{ dictionary[Header.user] = user?.getDictionary() }
        if id != nil{ dictionary[Header.id] = id }
        if likes != nil{ dictionary[Header.likes] = likes }
        if width != nil{ dictionary[Header.width] = width }
        if createdAt != nil{ dictionary[Header.created_at] = createdAt }
        if urls != nil{ dictionary[Header.urls] = urls?.getDictionary() }
        if currentUserCollections != nil{ dictionary[Header.currentUserCollection] = currentUserCollections }
        if links != nil{ dictionary[Header.links] = links?.getDictionary() }
        dictionary[Header.likedByUser] = likedByUser
        if categories != nil{ dictionary[Header.categories] = categories?.map { $0.getDictionary() } }
        if color != nil{ dictionary[Header.color] = color }
        return dictionary
    }
}
