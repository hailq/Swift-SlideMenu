//
//  MenuSegue.swift
//  SwiftSideMenu
//
//  Created by Hai Luong Quang on 11/22/14.
//  Copyright (c) 2014 Hai Luong Quang. All rights reserved.
//

import UIKit

class MenuSegue: UIStoryboardSegue {
    override func perform() {
        
        let menuController: MenuTableViewController = self.sourceViewController as! MenuTableViewController
        let rootController: RootSideMenuViewController = menuController.parentViewController as! RootSideMenuViewController
        
        rootController.changeContentController(self.destinationViewController as! UIViewController)
    }
}
