//
//  BackgroundDataProvider.swift
//  WatchOnlyAppDemo WatchKit Extension
//
//  Created by Charles Wang on 2022/8/26.
//

import Foundation

class BackgroundDataProvider: NSObject, URLSessionDownloadDelegate {
    private lazy var backgroundURLSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "backgoundTask")
        config.isDiscretionary = false // not use system discretion
        config.sessionSendsLaunchEvents = true // app will launch
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)// nil will send to background serial queue
    }()
    
    private var backgroundTask: URLSessionDownloadTask? = nil
    
    var completionHandler: ((_ update: Bool) -> Void)?
    
    func refresh(completionHandler: ((_ update: Bool) -> Void)?) {
        self.completionHandler = completionHandler
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        //API 拿到後資料存在 location url位置
        do {
            let data = try Data(contentsOf: location)
            let dataString = String(data: data, encoding: .utf8)
            print("wk receive dataString:\(String(describing: dataString))")
        } catch {
            print("wk receive data error:\(error.localizedDescription)")
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("wk didCompleteWithError:\(String(describing: error))")
        DispatchQueue.main.async {
            self.completionHandler?(error == nil)
            self.completionHandler = nil
        }
    }
    
    func schedule(_ first: Bool) {
        print("wk schedule background url task")
        if backgroundTask == nil {
            guard let url = URL(string: "https://delivery.twmebook.match.net.tw/DeliverWebV30/times/now.jsp") else {
                return
            }
            let bgTask = backgroundURLSession.downloadTask(with: url)
            bgTask.earliestBeginDate = Date().addingTimeInterval(first ? 15 : 15)
//            bgTask.countOfBytesExpectedToSend = 200
//            bgTask.countOfBytesExpectedToReceive = 1024
            bgTask.resume()
            backgroundTask = bgTask
            print("wk schedule background url task start")
        }
    }
}
