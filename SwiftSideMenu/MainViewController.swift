//
//  MainViewController.swift
//  SwiftSideMenu
//
//  Created by Hai Luong Quang on 11/21/14.
//  Copyright (c) 2014 Hai Luong Quang. All rights reserved.
//

import UIKit



class MainViewController: UIViewController {

    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerBar: UINavigationBar!
    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var navIcon: UIBarButtonItem!
    
    var rootViewController: RootSideMenuViewController?
    var currentContentController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup root controller
        self.rootViewController = self.parentViewController as? RootSideMenuViewController
        
        // Setup image for nav icon
        self.navIcon.title = nil
        self.navIcon.image = self.drawNavIcon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action methods
    @IBAction func toggleLeftMenu(sender: AnyObject) {
        self.toggleLeftMenu()
    }
    
    // MARK: - Public api
    /*
    // Draw the three line nav icon
    // You can custom it to display your icon
    */
    func drawNavIcon() -> UIImage? {
        /*
        
        let image: UIImage? = UIImage(named: "navIcon.png")
        return image
        
        // Uncomment this to using your custom image
        // comment all the codes below
        
        */
        
        let frameWidth: CGFloat = 18.0
        let frameHeight: CGFloat = 12.0
        
        // Get drawing context
        UIGraphicsBeginImageContext(CGSize(width: frameWidth, height: frameHeight))
        let context = UIGraphicsGetCurrentContext()
        
        // Draw the image
        let lineWidth: CGFloat = 2.0

        CGContextSetLineWidth(context, lineWidth)
        CGContextSetStrokeColorWithColor(context, UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0).CGColor)
        
        CGContextMoveToPoint(context, 0.0, lineWidth/2)
        CGContextAddLineToPoint(context, frameWidth, lineWidth/2)
        
        CGContextMoveToPoint(context, 0.0, frameHeight/2)
        CGContextAddLineToPoint(context, frameWidth, frameHeight/2)
        
        CGContextMoveToPoint(context, 0.0, frameHeight - lineWidth / 2)
        CGContextAddLineToPoint(context, frameWidth, frameHeight - lineWidth / 2)
        
        CGContextStrokePath(context)
        
        var image = UIGraphicsGetImageFromCurrentImageContext() // Return UIImage
        UIGraphicsEndImageContext()
        
        return image
    }

    
    /*
    // Show or hide the header bar

        @isShow: Bool
        // true: show the bar
        // false: hide the bar
    */
    func showHeader(isShow: Bool) {
        if (isShow == false && self.headerBar != nil) {
            self.headerBar.removeFromSuperview()
            
            // Resetup content frame
            var frame = self.contentView.frame
            var newFrame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height)
            
            self.contentView.frame = newFrame
        }
    }
    
    
    /*
    // Change the title of the header bar after view appeared
        @titleContent: String
    */
    func setHeaderTitle(titleContent: String?) {
        self.titleLabel.title = titleContent
    }
    
    /*
    // Open the left menu
    */
    func openLeftMenu() {
        self.rootViewController?.openLeftMenu()
    }
    
    /*
    // Close the left menu
    */
    func closeLeftMenu() {
        self.rootViewController?.closeLeftMenu()
    }
    
    /*
    // Toggle the left menu status
    */
    func toggleLeftMenu() {
        self.rootViewController?.toggleLeftMenu()
    }
    
}
