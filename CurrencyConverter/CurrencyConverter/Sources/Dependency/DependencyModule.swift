//
//  DependencyModule.swift
//  CurrencyConverter
//
//  Created by Alexander Ivlev on 24/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

class DependencyModule : DIStartupModule {
  override func load(builder: DIContainerBuilder) {
    try! builder.register(Server)
        .asType(ServerProtocol)
        .instanceSingle()
        .initializer { _ -> (Server) in return Server() }
  }
}
