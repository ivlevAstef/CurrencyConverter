//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Alexander Ivlev on 24/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit
import DITranquillity

class MainViewController: UIViewController {
  let server : ServerProtocol
  
  required init?(coder aDecoder: NSCoder) {
    server = *!DIMain.container!
    
    super.init(coder: aDecoder)
  }
  
  private var mainView: MainView! { return self.view as! MainView }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

