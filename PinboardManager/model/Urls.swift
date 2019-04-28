//
//  Urls.swift
//  PinboardManager
//
//  Created by Aayush Maheshwari on 24/04/19.
//  Copyright © 2019 aayushm95. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
struct URLKeys {
    let full = String("full")
    let small = String("small")
    let thumb = String("thumb")
    let regular = String("regular")
    let raw = String("raw")
}

open class Urls: NSCoding {
    
    public var full: String?
    public var small: String?
    public var thumb: String?
    public var regular: String?
    public var raw: String?
    private let Header = URLKeys()
    public var rawImage: UIImage?
    public var smallImage: UIImage?
    public var regularImage: UIImage?
    public var thumbImage: UIImage?
    public var fullImage: UIImage?
    convenience public init(object: Any) {
        self.init(json: JSON(object))
    }
    
   public init(json: JSON) {
        full = json[Header.full].string
        small = json[Header.small].string
        thumb = json[Header.thumb].string
        regular = json[Header.regular].string
        raw = json[Header.raw].string
    if raw != nil {
        Downloader.shared.download(url: (raw)!, successBlock: { [weak self] (data) in
            let image = UIImage(data: data)
            self?.rawImage = image
        }, failureBlock: { (error) in
            print("downloading image with url:\(self.raw) error: \(error)")
        })
    }
    if small != nil {
        Downloader.shared.download(url: (small)!, successBlock: { [weak self] (data) in
            let image = UIImage(data: data)
            self?.smallImage = image
        }, failureBlock: { (error) in
            print("downloading image with url:\(self.small) error: \(error)")
        })
    }
    if regular != nil {
        Downloader.shared.download(url: (regular)!, successBlock: { [weak self] (data) in
            let image = UIImage(data: data)
            self?.regularImage = image
        }, failureBlock: { (error) in
            print("downloading image with url:\(self.regular) error: \(error)")
        })
    }
    if thumb != nil {
        Downloader.shared.download(url: (thumb)!, successBlock: { [weak self] (data) in
            let image = UIImage(data: data)
            self?.thumbImage = image
        }, failureBlock: { (error) in
            print("downloading image with url:\(self.thumb) error: \(error)")
        })
    }
    if full != nil {
        Downloader.shared.download(url: (full)!, successBlock: { [weak self] (data) in
            let image = UIImage(data: data)
            self?.fullImage = image
        }, failureBlock: { (error) in
            print("downloading image with url:\(self.full) error: \(error)")
        })
    }
}
    
    func getDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if full != nil { dict[Header.full] = full }
        if small != nil { dict[Header.small] = small }
        if thumb != nil { dict[Header.thumb] = thumb }
        if regular != nil { dict[Header.regular] = regular }
        if raw != nil { dict[Header.raw] = raw }
        return dict
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(full, forKey: Header.full)
        aCoder.encode(small, forKey: Header.small)
        aCoder.encode(thumb, forKey: Header.thumb)
        aCoder.encode(regular, forKey: Header.regular)
        aCoder.encode(raw, forKey: Header.raw)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.full = aDecoder.decodeObject(forKey: Header.full) as? String
        self.small = aDecoder.decodeObject(forKey: Header.small) as? String
        self.thumb = aDecoder.decodeObject(forKey: Header.thumb) as? String
        self.regular = aDecoder.decodeObject(forKey: Header.regular) as? String
        self.raw = aDecoder.decodeObject(forKey: Header.raw) as? String
    }
    
    
}
