//
//  SIALog.swift
//  SIALogger
//
//  Created by Alexander Ivlev on 30/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

//Log Levels
public extension SIALog {
  public static func Fatal(msg: String, file: StaticString = #file, line: UInt = #line) {
    log(SIALogLevel.Fatal, msg: msg, file: file, line: line)
    abort()
  }
  
  public static func Error(msg: String, file: StaticString = #file, line: UInt = #line) {
    log(SIALogLevel.Error, msg: msg, file: file, line: line)
  }
  
  public static func Warning(msg: String, file: StaticString = #file, line: UInt = #line) {
    log(SIALogLevel.Warning, msg: msg, file: file, line: line)
  }
  
  public static func Info(msg: String, file: StaticString = #file, line: UInt = #line) {
    log(SIALogLevel.Info, msg: msg, file: file, line: line)
  }
  
  public static func Trace(msg: String, file: StaticString = #file, line: UInt = #line) {
    log(SIALogLevel.Trace, msg: msg, file: file, line: line)
  }
}

//Assertions
public extension SIALog {
  public static func Assert(condition: Bool, msg: String = "", file: StaticString = #file, line: UInt = #line) {
    guard condition else {
      let message = "Activate assert with message: " + msg
      log(SIALogLevel.Fatal, msg: message, file: file, line: line)
      assert(condition, message, file: file, line: line)
      return
    }
  }
  
  public static func Check(condition: Bool, file: StaticString = #file, line: UInt = #line) {
    if condition {
      Fatal("Check failed", file: file, line: line)
    }
  }
  
  public static func NotImplemented(file: StaticString = #file, line: UInt = #line, method: String = #function) {
    Assert(false, msg: ("Not Implemented: " + method), file: file, line: line)
  }
}

//Log if
public extension SIALog {
  public static func FatalIf(condition: Bool, msg: String, file: StaticString = #file, line: UInt = #line) {
    If(condition, method: Fatal, msg: msg, file: file, line: line)
  }
  
  public static func ErrorIf(condition: Bool, msg: String, file: StaticString = #file, line: UInt = #line) -> Bool {
    return If(condition, method: Error, msg: msg, file: file, line: line)
  }
  
  public static func WarningIf(condition: Bool, msg: String, file: StaticString = #file, line: UInt = #line) -> Bool {
    return If(condition, method: Warning, msg: msg, file: file, line: line)
  }
  
  public static func InfoIf(condition: Bool, msg: String, file: StaticString = #file, line: UInt = #line) -> Bool {
    return If(condition, method: Info, msg: msg, file: file, line: line)
  }
  
  public static func TraceIf(condition: Bool, msg: String, file: StaticString = #file, line: UInt = #line) -> Bool {
    return If(condition, method: Trace, msg: msg, file: file, line: line)
  }
  
  private static func If(condition: Bool, method: (String, StaticString, UInt) -> (), msg: String, file: StaticString = #file, line: UInt = #line) -> Bool {
    if condition {
      method(msg, file, line)
    }
    return condition
  }
}

public final class SIALog {
  private static let monitor = NSObject()
  private static let dateFormatter = { () -> NSDateFormatter in
    let result = NSDateFormatter()
    result.timeZone = NSTimeZone(name: "UTC")
    return result
  }()
  
  private static func log(level: SIALogLevel, msg: String, file filePath: StaticString = #file, line: UInt = #line) {
    guard level.rawValue <= SIALogConfig.maxLogLevel.rawValue else {
      return
    }
    
    objc_sync_enter(monitor) //lock
    dateFormatter.dateFormat = SIALogConfig.formatTime
    
    let logMsg = SIALogMessage(time : dateFormatter.stringFromDate(NSDate()),
                               level: level,
                               file: (String(filePath) as NSString).lastPathComponent,
                               line: line,
                               text: msg)
    
    for output in SIALogConfig.outputs {
      output.log(logMsg)
    }
    
    objc_sync_exit(monitor) //unlock
  }
}