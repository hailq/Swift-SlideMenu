//
//  ContentViewController.swift
//  SwiftSideMenu
//
//  Created by Hai Luong Quang on 11/21/14.
//  Copyright (c) 2014 Hai Luong Quang. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var mainSideMenuController: MainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.parent != nil && self.parent!.isKind(of: MainViewController.self) {
            self.mainSideMenuController = self.parent as? MainViewController
        }
        
        // Set title
        self.title = "Google Web View"

        // Do any additional setup after loading the view.
        let url: URL = URL(string: "https://www.google.com.vn")!
        let urlRequest: URLRequest = URLRequest(url: url)
        self.webView.loadRequest(urlRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
