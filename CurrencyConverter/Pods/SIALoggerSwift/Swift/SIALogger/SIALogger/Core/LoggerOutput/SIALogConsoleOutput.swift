//
//  SIALogConsoleOutput.swift
//  SIALogger
//
//  Created by Alexander Ivlev on 31/05/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

public class SIALogConsoleOutput : SIALogOutputProtocol {
  public static let defaultLogFormat = "%t [%U] {%f:%l}: %m"
  
  public convenience init() {
    self.init(logFormat: SIALogConsoleOutput.defaultLogFormat)
  }
  
  public required init(logFormat: String) {
    formatter = SIALogFormatter(format: logFormat)
  }
  
  public func log(msg: SIALogMessage) {
    print(formatter.toString(msg))
  }
  
  private let formatter: SIALogFormatter
}