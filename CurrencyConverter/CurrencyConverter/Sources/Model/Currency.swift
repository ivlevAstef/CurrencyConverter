//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Alexander Ivlev on 24/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

class Currency: NSObject {
  let name: String
  let value: Double
  
  init(name: String, value: Double) {
    self.name = name
    self.value = value
  }
  
  override var description : String {
    return "{Currency Name:\(name) Value:\(value)}"
  }
  
  override var debugDescription : String {
    return "{Currency Name:\(name) Value:\(value)}"
  }
  
}
