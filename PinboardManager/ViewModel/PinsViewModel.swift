//
//  PinsViewModel.swift
//  PinboardManager
//
//  Created by Aayush Maheshwari on 25/04/19.
//  Copyright © 2019 aayushm95. All rights reserved.
//

import SwiftyJSON

open class PinsViewModel: DownloadStatus {
    public var pins : [Pin]
    public var urlstring: String
    public var notificationName : Notification.Name    
    public func fetchPins()
    {
        Downloader.shared.download(url: urlstring, status: self)
    }
    
    public init(){
        pins = [Pin]()
        urlstring = "http://pastebin.com/raw/wgkJgazE"
        notificationName = Notification.Name("DidReceivePins")
    }
    public func downloaded(item: Data) {
        let fetchedObjects = JSON(item)
        if fetchedObjects.array != nil {
            for object in fetchedObjects.array! {
                let item = Pin.init(json: object)
                self.pins.append(item)
            }
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }
    
    public func downloadFailed(forUrl url: String, error: Error) {
        let userInfo:[String: Error] = ["error": error]
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: userInfo)
    }
}
