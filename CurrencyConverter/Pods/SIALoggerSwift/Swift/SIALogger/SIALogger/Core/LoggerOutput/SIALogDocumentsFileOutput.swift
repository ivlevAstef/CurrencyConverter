//
//  SIALogDocumentsFileOutput.swift
//  SIALogger
//
//  Created by Alexander Ivlev on 31/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

public class SIALogDocumentsFileOutput : SIALogOutputProtocol {
  public static let defaultLogFormat = "%t [%3] {%f:%l}: %m"
  
  public convenience init?(fileName: String, joinDate: Bool = true) {
    self.init(logFormat: SIALogDocumentsFileOutput.defaultLogFormat, fileName: fileName, joinDate: joinDate)
  }
  
  public required init?(logFormat: String, fileName: String, joinDate: Bool = true) {
    guard let filePath = SIALogDocumentsFileOutput.createFilePath(fileName, joinDate: joinDate) else {
      return nil
    }
    
    NSFileManager.defaultManager().createFileAtPath(filePath, contents: nil, attributes: nil)
    
    guard let outputHandle = NSFileHandle(forWritingAtPath: filePath) else {
      return nil
    }
    
    formatter = SIALogFormatter(format: logFormat)
    self.outputHandle = outputHandle
  }
  
  public func log(msg: SIALogMessage) {
    if let data = (formatter.toString(msg) + "\r\n").dataUsingEncoding(NSUTF8StringEncoding) {
      self.outputHandle.writeData(data)
    }
  }
  
  
  private let formatter: SIALogFormatter
  private let outputHandle : NSFileHandle
  
  private static func createFilePath(fileName: String, joinDate: Bool) -> String? {
    guard let documentDirectory = SIALogDocumentsFileOutput.documentsDirectory() else {
      return nil
    }
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd_HHmmss";
    dateFormatter.timeZone = NSTimeZone(name: "UTC")
    
    return documentDirectory+"/"+fileName+"_"+dateFormatter.stringFromDate(NSDate())+".log"
  }
  
  private static func documentsDirectory() -> String? {
    let directory = NSSearchPathDirectory.DocumentDirectory;
    let domainMask = NSSearchPathDomainMask.AllDomainsMask;
    
    guard let dir = NSSearchPathForDirectoriesInDomains(directory, domainMask, true).first else {
      return nil
    }
    return dir
  }
}