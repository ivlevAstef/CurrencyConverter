//
//  ServerRequest.swift
//  CurrencyConverter
//
//  Created by Alexander Ivlev on 24/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation
import SIALoggerSwift

class ServerRequest {
  private static let URL = "http://api.fixer.io/"
  private static let Timeout = 15.0
  
  init(method: String) {
    requestURL = ServerRequest.URL + method
  }
  
  func GET(callback: (data: NSData?, error: String?) -> ()) {
    SIALog.Info("GET \(requestURL) Request Started")
    let request = NSMutableURLRequest(URL: NSURL(string: requestURL)!)
    request.timeoutInterval = ServerRequest.Timeout
    
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) {dataOpt, _, errorOpt in
      SIALog.Info("GET \(self.requestURL) Request Ended")
      if let error = errorOpt {
        callback(data: nil, error: error.localizedDescription)
        return
      }
      
      guard let data = dataOpt else {
        callback(data: nil, error: "Data is nil")
        return
      }
      
      SIALog.Trace("Response data: \(String(data: data, encoding: NSUTF8StringEncoding))")
      callback(data: data, error: nil)
    }
    
    task.resume()
  }
  
  private let requestURL: String
}