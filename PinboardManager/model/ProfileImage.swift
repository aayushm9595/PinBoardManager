//
//  ProfileImage.swift
//  PinboardManager
//
//  Created by Aayush Maheshwari on 23/04/19.
//  Copyright © 2019 aayushm95. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
struct  ProfileImageKeys {
    let large = String("large")
    let small = String("small")
    let medium = String("medium")
    
}
open class ProfileImage: NSCoding {
    
    
    // MARK: Properties
    public var large: String?
    public var small: String?
    public var medium: String?
    private let Header = ProfileImageKeys()
    public var smallImage: UIImage?
    public var mediumImage: UIImage?
    public var largeImage: UIImage?
    convenience public init(object: Any) {
        self.init(json: JSON(object))
    }
    
   public init(json: JSON) {
        large = json[Header.large].string
        small = json[Header.small].string
        medium = json[Header.medium].string
    if small != nil {
        Downloader.shared.download(url: (small)!, successBlock: { [weak self] (data) in
            let image = UIImage(data: data)
            self?.smallImage = image
            }, failureBlock: { (error) in
                print("downloading image with url:\(self.small) error: \(error)")
        })
    }
    if medium != nil {
        Downloader.shared.download(url: (medium)!, successBlock: { [weak self] (data) in
            let image = UIImage(data: data)
            self?.mediumImage = image
            }, failureBlock: { (error) in
                print("downloading image with url:\(self.medium) error: \(error)")
        })
    }
    if large != nil{
        Downloader.shared.download(url: (large)!, successBlock: { [weak self] (data) in
            let image = UIImage(data: data)
            self?.largeImage = image
            }, failureBlock: { (error) in
                print("downloading image with url:\(self.large) error: \(error)")
        })
    }
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    func getDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if large != nil { dict[Header.large] = large }
        if small != nil { dict[Header.small] = small }
        if medium != nil { dict[Header.medium] = medium }
        return dict
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.large = aDecoder.decodeObject(forKey: Header.large) as? String
        self.small = aDecoder.decodeObject(forKey: Header.small) as? String
        self.medium = aDecoder.decodeObject(forKey: Header.medium) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(large, forKey: Header.large)
        aCoder.encode(small, forKey: Header.small)
        aCoder.encode(medium, forKey: Header.medium)
    }
}
