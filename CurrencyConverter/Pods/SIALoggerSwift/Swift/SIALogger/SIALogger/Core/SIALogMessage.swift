//
//  SIALogMessage.swift
//  SIALogger
//
//  Created by Alexander Ivlev on 06/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

public class SIALogMessage {
  public let time : String
  public let level : SIALogLevel
  public let file : String
  public let line : UInt
  public let text : String
  
  public required init(time: String, level: SIALogLevel, file: String, line: UInt, text: String) {
    self.time = time
    self.level = level
    self.file = file
    self.line = line
    self.text = text
  }
}