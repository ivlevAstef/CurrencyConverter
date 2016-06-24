//
//  SIALogLevel.swift
//  SIALogger
//
//  Created by Alexander Ivlev on 31/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public enum SIALogLevel : Int {
  case Fatal = 0
  case Error
  case Warning
  case Info
  case Trace
  
  public func toString() -> String {
    switch self {
    case .Fatal:
      return "Fatal"
    case .Error:
      return "Error"
    case .Warning:
      return "Warning"
    case .Info:
      return "Info"
    case .Trace:
      return "Trace"
    }
  }
  
  public func toShortString() -> String {
    switch self {
    case .Fatal:
      return "FTL"
    case .Error:
      return "ERR"
    case .Warning:
      return "WRN"
    case .Info:
      return "INF"
    case .Trace:
      return "TRC"
    }
  }
}