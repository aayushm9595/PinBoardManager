//
//  User.swift
//  PinboardManager
//
//  Created by Aayush Maheshwari on 24/04/19.
//  Copyright © 2019 aayushm95. All rights reserved.
//

import Foundation
import  SwiftyJSON

struct UserKeys {
    let profileimage = String("profile_image")
    let links = String("links")
    let name = String("name")
    let id = String("id")
    let username = String("username")
}

open class User: NSCoding {
    public var profileImage: ProfileImage?
    public var links: Links?
    public var name: String?
    public var id: String?
    public var username: String?
    private let Header = UserKeys()
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(profileImage, forKey: Header.profileimage)
        aCoder.encode(links, forKey: Header.links)
        aCoder.encode(name, forKey: Header.name)
        aCoder.encode(id, forKey: Header.id)
        aCoder.encode(username, forKey: Header.username)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.profileImage = aDecoder.decodeObject(forKey: Header.profileimage) as? ProfileImage
        self.links = aDecoder.decodeObject(forKey: Header.links) as? Links
        self.name = aDecoder.decodeObject(forKey: Header.name) as? String
        self.id = aDecoder.decodeObject(forKey: Header.id) as? String
        self.username = aDecoder.decodeObject(forKey: Header.username) as? String
    }
    
    convenience public init(object: Any)
    {
        self.init(json : JSON(object))
    }
    
   public init(json: JSON)
    {
        profileImage = ProfileImage(json: json[Header.profileimage])
        links = Links(json: json[Header.links])
        name = json[Header.name].string
        id = json[Header.id].string
        username = json[Header.username].string
    }
    
    func getDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if profileImage != nil { dict[Header.profileimage] = profileImage?.getDictionary() }
        if links != nil { dict[Header.links] = links?.getDictionary() }
        if name != nil { dict[Header.name] = name }
        if id != nil { dict[Header.id] = id }
        if username != nil { dict[Header.username] = username }
        return dict
    }
}
