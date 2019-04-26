//
//  DownloadManager.swift
//  PinboardManager
//
//  Created by Aayush Maheshwari on 24/04/19.
//  Copyright © 2019 aayushm95. All rights reserved.
//

import Foundation

public protocol DownloadStatus: class  {
    func downloaded(item: Data)
    func downloadFailed(forUrl url: String, error : Error)
}

public enum DownloadState {
    case none, pending, finished, failed
}

open class Downloader {
    static let shared = Downloader()
    let cacheManager = CacheManager(config : CacheConfiguration.default())
    
    private var downloads = [String:DownloadItem]()
    
    func download(url: String, status: DownloadStatus) {
        
        let item = itemFromCache(url: url)
        if item != nil {
            status.downloaded(item: item!)
            return
        }
        
        var downloadItem = self.downloads[url]
        
        if downloadItem == nil {
            downloadItem = DownloadItem(url: url, status: status)
        }
        
        if downloadItem!.state == .pending {
            return
        }
        self.downloads[url] =  downloadItem
        doDownload(downloadItem: downloadItem!)
        
    }
    
    func download(url: String,successBlock: @escaping (Data) ->(), failureBlock: @escaping (Error?) ->()) {
        let item = itemFromCache(url: url)
        if item != nil {
            successBlock(item!)
            return
        }
        
        var downloadItem = self.downloads[url]
        
        if downloadItem == nil {
            let notifier = ClosureNotifier(successBlock: successBlock, failureBlock: failureBlock)
            downloadItem = DownloadItem(url: url, closureNotifier: notifier)
        }
        
        if downloadItem!.state == .pending {
            return
        }
        
        self.downloads[url] =  downloadItem
        doDownload(downloadItem: downloadItem!)
    }
    
    private func itemFromCache(url: String) -> Data? {
        let cachedItem = cacheManager.getItem(url: url)
        return cachedItem
    }
    
    private func doDownload (downloadItem: DownloadItem) {
        
        let dataTask = URLSession.shared.dataTask(with: URL(string: downloadItem.url)!) { (data, response, error) in
            
            defer {
                self.downloads.removeValue(forKey: downloadItem.url)
            }
            
            if error != nil {
                downloadItem.notifyFailure(error: error!)
                return
            }
            
            guard data != nil else {
                
                let emptyError = self.createEmptyDataError()
                
                downloadItem.notifyFailure(error: emptyError)
                return
            }
            
            downloadItem.notifySuccess(data: data!)
            self.cacheManager.set(url: downloadItem.url, item: data!)
        }
        
        dataTask.resume()
        
        downloadItem.downloadTask = dataTask
        downloadItem.state = .pending
    }
    
    func cancelDownload(url: String, observer: DownloadStatus) {
        let downloadItem = downloads[url]
        if downloadItem != nil {
            downloadItem?.removeObserver(statusDismissed: observer)
            if downloadItem?.ItemsStatus.count == 0 {
                
                let safeToCancelBlocks = downloadItem?.blocksObservers.count == 0 || downloadItem?.blocksObservers.count == 1
                let noObjectObservers = downloadItem?.ItemsStatus.count == 0
                
                if noObjectObservers && safeToCancelBlocks {
                    downloadItem?.downloadTask?.cancel()
                    downloads.removeValue(forKey: downloadItem!.url)
                }
            }
        }
    }
    
    func createEmptyDataError() -> NSError {
        let userInfo: [NSObject : AnyObject] =
            [
                NSLocalizedDescriptionKey as NSObject :  NSLocalizedString("Empty Data", value: "empty response from url", comment: "") as AnyObject,
                NSLocalizedFailureReasonErrorKey as NSObject : NSLocalizedString("Empty Data", value: "empty response from url", comment: "") as AnyObject
        ]
        let emptyError = NSError(domain: "DownloaderResponseErrorDomain", code: 200, userInfo: userInfo as? [String : Any])
        
        return emptyError
    }
}

open class DownloadItem {
    public var state: DownloadState = .none
    private(set) var downloadedItem: Data?
    public var ItemsStatus = [DownloadStatus]()
    public var blocksObservers = [ClosureNotifier]()
    
    public var url: String
    public var downloadTask: URLSessionDataTask?
    
   public init(url: String, status: DownloadStatus) {
        self.url = url
        self.ItemsStatus.append(status)
    }
    
   public init(url: String, itemsStatus: [DownloadStatus]) {
        self.url = url
        self.ItemsStatus.append(contentsOf: itemsStatus)
    }
    
   public init(url: String, closureNotifier: ClosureNotifier) {
        self.url = url
        self.blocksObservers.append(closureNotifier)
    }
    
    func add(status: DownloadStatus) {
        ItemsStatus.append(status)
        // may check for status and if already downloaded update observer
        // second thought check status if
    }
    
    func removeObserver(statusDismissed: DownloadStatus) {
        for (index, status) in self.ItemsStatus.enumerated() {
            if status === statusDismissed {
                self.ItemsStatus.remove(at: index)
            }
        }
    }
    
    func notifySuccess(data: Data) {
        downloadedItem = data
        self.state = .finished
        
        for individualStatus in ItemsStatus {
            individualStatus.downloaded(item: downloadedItem!)
        }
        
        for blockNotifier in blocksObservers {
            blockNotifier.successBlock(data)
        }
        finalize()
    }
    
    func notifyFailure(error: Error)
    {
        self.state = .failed
        for individualStatus in ItemsStatus {
            individualStatus.downloadFailed(forUrl: url, error: error)
        }
        
        for blockNotifier in blocksObservers {
            blockNotifier.failureBlock(error)
        }
        
        finalize()
    }
    
    func finalize() {
        ItemsStatus.removeAll()
        blocksObservers.removeAll()
    }
}

open class ClosureNotifier: NSObject {
    public var successBlock: (Data) ->()
    public var failureBlock: (Error?) ->()
   public init(successBlock: @escaping (Data) ->(), failureBlock: @escaping (Error?) ->()) {
        self.successBlock = successBlock
        self.failureBlock = failureBlock
    }
}

