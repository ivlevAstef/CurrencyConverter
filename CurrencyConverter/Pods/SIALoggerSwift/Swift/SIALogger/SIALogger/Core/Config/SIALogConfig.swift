//
//  SIALogConfig.swift
//  SIALogger
//
//  Created by Alexander Ivlev on 31/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public struct SIALogConfig {
  public static var maxLogLevel = defaultMaxLogLevel
  public static var outputs = defaultOutputs
  public static var formatTime = defaultFormatTime
  
  public static let defaultMaxLogLevel = SIALogLevel.Info
  public static let defaultOutputs : [SIALogOutputProtocol] = [SIALogConsoleOutput()]
  public static let defaultFormatTime = "HH:mm:ss:SSS"
}